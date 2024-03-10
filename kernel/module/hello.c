#include "internal.h"
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/kthread.h>
#include <linux/module.h>
#include <linux/semaphore.h>

//  Define the module metadata.
#define MODULE_NAME "lab"
MODULE_AUTHOR("Martins3");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A simple kernel module to greet a user");
MODULE_VERSION("0.1");

//  Define the name parameter.
static char *name = "martins3";
module_param(name, charp, S_IRUGO);
MODULE_PARM_DESC(name, "The name to display in /var/log/kern.log");

//
// int rcu_x, rcu_y;
// int rcu_thread0(void *idx);
//
// int rcu_thread0(void *idx)
// {
// 	int r1, r2;
// 	int t_id = *(int *)idx;
// 	while (!kthread_should_stop()) {
// 		rcu_read_lock();
// 		r1 = READ_ONCE(rcu_x);
// 		r2 = READ_ONCE(rcu_y);
// 		rcu_read_unlock();
// 		BUG_ON(r1 == 0 && r2 == 1);
// 	}
// 	printk(KERN_INFO "thread %d stopped\n", t_id);
// 	return 0;
// }
//
// int rcu_thread1(void *idx);
// int rcu_thread1(void *idx)
// {
// 	int t_id = *(int *)idx;
//
// 	while (!kthread_should_stop()) {
// 		WRITE_ONCE(rcu_x, 1);
// 		synchronize_rcu(); // TODO 将这一行注释掉，并没有什么触发 BUG_ON 直到
// 			// softlock up
// 		WRITE_ONCE(rcu_y, 1);
// 	}
//
// 	printk(KERN_INFO "thread %d stopped\n", t_id);
// 	return 0;
// }
//
//
// static void hacking_rcu(void)
// {
// 	initialize_thread(rcu_thread0, "martins3", 0);
// 	initialize_thread(rcu_thread1, "martins3", 1);
// }

static int kthread_sleep(void *arg)
{
	long x = (long)arg;
	pr_info("[martins3:%s:%d] %ld\n", __FUNCTION__, __LINE__, x);
	msleep(1000);
	return 0;
}

static struct task_struct *kthread_task;
int test_kthread(int action)
{
	if (action) {
		kthread_task =
			create_thread("sleep", kthread_sleep, (void *)123);
		if (kthread_task == NULL)
			return -ENOMEM;
	} else {
		stop_thread(kthread_task);
		kthread_task = NULL;
	}
	return 0;
}

/**
 *
 * echo 0 > /sys/kernel/hacking/watchdog
 * 测试 softlock 的效果。虽然存在时钟中断，但是此内核是 voluntery preempt 的，
 * 所以即使没有屏蔽时钟中断，该进程还是不能被调度走。
 *
 * 当 echo full > /sys/kernel/debug/sched/preempt 之后，
 * echo 0 > /sys/kernel/hacking/watchdog 无论等待多长时间都不会出现 softlock up
 */
int test_watchdog(int action)
{
	bool disable_irq = false;
	bool no_signal_check = false;
	bool enable_sched = false;
	bool disable_preempt = false;
	bool rcu_critical = false;
	bool might_sleep = false;

	disable_irq = action % 10;
	no_signal_check = (action / 10) % 10;
	enable_sched = (action / 100) % 10;
	disable_preempt = (action / 1000) % 10;
	rcu_critical = (action / 10000) % 10;
	might_sleep = (action / 100000) % 10;

	pr_info("watchdog : %s %s %s %s %s %s\n",
		might_sleep ? "might_sleep" : "", rcu_critical ? "rcu" : "",
		disable_preempt ? "disable_preempt" : "",
		enable_sched ? "enable_sched" : "",
		no_signal_check ? "no_signal_check" : "",
		disable_irq ? "disable_irq" : "");

	if (disable_irq)
		local_irq_disable();

	if (disable_preempt)
		preempt_disable();

	if (rcu_critical)
		rcu_read_lock();

	for (;;) {
		// 无论是否屏蔽中断，signal_pending 都是可以接受到的，原因 bash 父进程传递的
		// 无论是否屏蔽中断，ctrl-c 都是无法打断当前进程的
		if (no_signal_check && signal_pending(current))
			break;

		if (enable_sched)
			cond_resched();

		// 在 voluntery preempt + might_sleep 的时候，可以
		if (might_sleep)
			might_sleep();

		cpu_relax();
	}

	if (disable_irq)
		local_irq_enable();

	if (disable_preempt)
		preempt_enable();

	if (rcu_critical)
		rcu_read_unlock();

	return 0;
}

/**
 * might_sleep - annotation for functions that can sleep
 *
 * this macro will print a stack trace if it is executed in an atomic
 * context (spinlock, irq-handler, ...). Additional sections where blocking is
 * not allowed can be annotated with non_block_start() and non_block_end()
 * pairs.
 *
 * This is a useful debugging help to be able to catch problems early and not
 * be bitten later when the calling function happens to sleep when it is not
 * supposed to.
 */
// 1. spinlock, irq-handler,  preempt disable 这些地方都不可以睡眠
// 2. spinlock 有时候必须屏蔽中断吧，如果不屏蔽，中断处理函数中重新持有这个锁会导致死锁

static DEFINE_SPINLOCK(sl_static);
int test_might_sleep(int action)
{
	unsigned long flags;

	switch (action) {
	case 0:
		spin_lock_irqsave(&sl_static, flags);
		might_sleep(); // 没有效果，因为没有打开 CONFIG_DEBUG_ATOMIC_SLEEP ，
			// 退化为 cond_resched ，而 cond_resched 在 irq 下不会切换的
		spin_unlock_irqrestore(&sl_static, flags);
		break;
	case 1:
		spin_lock_irqsave(&sl_static, flags);
		msleep(1000); // 会被检测出来
		spin_unlock_irqrestore(&sl_static, flags);
		break;
	case 2:
		preempt_disable();
		msleep(1000); // 也是会会被检测出来
		preempt_enable();
		break;
	case 3:
		// 无论是 preempt_disable 还是 spinlock ，kmalloc 和 kfree 不会被检测出来
		spin_lock_irqsave(&sl_static, flags);
		int *f = kmalloc(sizeof(int), GFP_KERNEL);
		kfree(f);
		spin_unlock_irqrestore(&sl_static, flags);
		break;
	case 4:
		preempt_disable();
		// cond_resched 的 condition 要求当前上下文可以 preempt，
		// 也就是 preempt_count 为 0 的时候才可以进行 schedule()
		// 所以这里不会出现问题
		cond_resched();
		preempt_enable();
		break;
	case 5:
		preempt_disable();
		// 这里会出现问题
		schedule();
		preempt_enable();
		break;
	case 6:
		rcu_read_lock();
		schedule(); // 在 rcu_note_context_switch 触发警告
		rcu_read_unlock();
		break;
	case 7:
		// 即便是设置
		// echo full > /sys/kernel/debug/sched/preempt
		//
		// 在 rcu critical 中循环，很快就出发了 rcu stall ditection
		rcu_read_lock();
		for (;;) {
			cpu_relax();
		}
		rcu_read_unlock();
		break;
	default:
		pr_info("Nothing");
		break;
	}

	return 0;
}

static ssize_t misc_show(struct kobject *kobj, struct kobj_attribute *attr,
			 char *buf)
{
	// https://www.kernel.org/doc/Documentation/printk-formats.txt
	pr_info("p=%p px=%px pf=%pf", current->mm->pgd, current->mm->pgd,
		misc_show);

	return sysfs_emit(buf, "%d\n", 1);
}

static int foo;
/*
 * The "foo" file where a static variable is read from and written to.
 */
static ssize_t foo_show(struct kobject *kobj, struct kobj_attribute *attr,
			char *buf)
{
	return sysfs_emit(buf, "%d\n", foo);
}

static ssize_t foo_store(struct kobject *kobj, struct kobj_attribute *attr,
			 const char *buf, size_t count)
{
	int ret;

	ret = kstrtoint(buf, 10, &foo);
	if (ret < 0)
		return ret;

	return count;
}

// 使用这个测试可以得到一个相当有趣的结果:
// 1. guest 中 htop 上 32 CPU 显示都是 0%
// 2. /proc/load_avg 持续升高，一直到 32
static int io_wait_sleep(void *arg)
{
	io_schedule();
	msleep(1000);
	return 0;
}

static struct task_struct *io_wait_threads[32];
int test_io_wait(int action)
{
	if (action && io_wait_threads[0])
		return -EINVAL;

	if (action == 0 && io_wait_threads[0] == NULL)
		return -EINVAL;

	if (action)
		for (int i = 0; i < 32; i++) {
			io_wait_threads[i] =
				create_thread("wait", io_wait_sleep, NULL);
			if (!io_wait_threads[i])
				BUG();
		}
	else
		for (int i = 0; i < 32; i++) {
			stop_thread(io_wait_threads[i]);
			io_wait_threads[i] = NULL;
		}

	return 0;
}

/* Sysfs attributes cannot be world-writable. */
static struct kobj_attribute foo_attribute =
	__ATTR(foo, 0664, foo_show, foo_store);
static struct kobj_attribute misc_attribute =
	__ATTR(misc, 0600, misc_show, NULL);

DEFINE_TESTER(watchdog)
DEFINE_TESTER(kthread)
DEFINE_TESTER(mutex)
DEFINE_TESTER(tracepoint)
DEFINE_TESTER(rcu_api)
DEFINE_TESTER(srcu)
DEFINE_TESTER(might_sleep)
DEFINE_TESTER(wait_event)
DEFINE_TESTER(atomic)
DEFINE_TESTER(io_wait)
DEFINE_TESTER(barrier)
DEFINE_TESTER(rwsem)
DEFINE_TESTER(complete)
DEFINE_TESTER(percpu_rwsem)
DEFINE_TESTER(preempt)
DEFINE_TESTER(workqueue)
DEFINE_TESTER(waitbit)
DEFINE_TESTER(rcuwait)
DEFINE_TESTER(access_once)

/*
 * Create a group of attributes so that we can create and destroy them all
 * at once.
 */
static struct attribute *attrs[] = {
	&misc_attribute.attr,
	&foo_attribute.attr,
	&watchdog_attribute.attr,
	&kthread_attribute.attr,
	&mutex_attribute.attr,
	&tracepoint_attribute.attr,
	&rcu_api_attribute.attr,
	&srcu_attribute.attr,
	&might_sleep_attribute.attr,
	&wait_event_attribute.attr,
	&atomic_attribute.attr,
	&io_wait_attribute.attr,
	&barrier_attribute.attr,
	&rwsem_attribute.attr,
	&complete_attribute.attr,
	&percpu_rwsem_attribute.attr,
	&preempt_attribute.attr,
	&workqueue_attribute.attr,
	&waitbit_attribute.attr,
	&rcuwait_attribute.attr,
	&access_once_attribute.attr,
	NULL, /* need to NULL terminate the list of attributes */
};

static struct attribute_group attr_group = {
	.attrs = attrs,
};

static struct kobject *mymodule;
static int __init greeter_init(void)
{
	int error = 0;
	mymodule = kobject_create_and_add("hacking", kernel_kobj);
	if (!mymodule)
		return -ENOMEM;

	error = sysfs_create_group(mymodule, &attr_group);
	if (error)
		kobject_put(mymodule);

	return error;
}

static void __exit greeter_exit(void)
{
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	kobject_put(mymodule);
}

module_init(greeter_init);
module_exit(greeter_exit);
