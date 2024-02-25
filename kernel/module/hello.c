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
static ssize_t kthread_store(struct kobject *kobj, struct kobj_attribute *attr,
			     const char *buf, size_t count)
{
	int ret;
	int start;
	ret = kstrtoint(buf, 10, &start);
	if (ret < 0)
		return ret;

	if (start) {
		kthread_task =
			create_thread("sleep", kthread_sleep, (void *)123);
		if (kthread_task == NULL)
			return -ENOMEM;
	} else {
		stop_thread(kthread_task);
		kthread_task = NULL;
	}
	return count;
}

static ssize_t watchdog_store(struct kobject *kobj, struct kobj_attribute *attr,
			      const char *buf, size_t count)
{
	int ret;
	int action;
	bool disable_irq = false;
	bool no_signal_check = false;
	bool enable_sched = false;
	bool disable_preempt = false;
	bool rcu = false;

	ret = kstrtoint(buf, 10, &action);
	if (ret < 0)
		return ret;

	disable_irq = action % 10;
	no_signal_check = (action / 10) % 10;
	enable_sched = (action / 100) % 10;
	disable_preempt = (action / 1000) % 10;
	rcu = (action / 10000) % 10;

	pr_info("watchdog : %s %s %s %s %s\n", rcu ? "rcu" : "",
		disable_preempt ? "disable_preempt" : "",
		enable_sched ? "enable_sched" : "",
		no_signal_check ? "no_signal_check" : "",
		disable_irq ? "disable_irq" : "");

	if (disable_irq)
		local_irq_disable();

	if (disable_preempt)
		preempt_disable();

	if (rcu)
		rcu_read_lock();

	for (;;) {
		// 无论是否屏蔽中断，signal_pending 都是可以接受到的，原因 bash 父进程传递的
		// 无论是否屏蔽，ctrl-c 都是无法打断当前进程的
		if (no_signal_check && signal_pending(current))
			break;

		if (enable_sched)
			cond_resched();

		cpu_relax();
	}

	if (disable_irq)
		local_irq_enable();

	if (disable_preempt)
		preempt_enable();

	if (rcu)
		rcu_read_unlock();

	return count;
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
// 1. 测试到底多少地方不可以睡眠 ? spinlock,  irq-handler,  preempt disable
// 3. spinlock 有时候必须屏蔽中断吧，如果不屏蔽，被中断了，会出现什么问题?

static DEFINE_SPINLOCK(sl_static);
static ssize_t might_sleep_store(struct kobject *kobj,
				 struct kobj_attribute *attr, const char *buf,
				 size_t count)
{
	int ret;
	int test;
	unsigned long flags;

	ret = kstrtoint(buf, 10, &test);
	if (ret < 0)
		return ret;

	switch (test) {
	case 0:
		spin_lock_irqsave(&sl_static, flags);
		might_sleep(); // TODO 不知道为什么，没有效果，难道是因为没有打开 CONFIG_DEBUG_ATOMIC_SLEEP 吗?
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
	default:
		pr_info("Nothing");
		break;
	}

	return count;
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
static struct kobj_attribute watchdog_attribute =
	__ATTR(watchdog, 0660, NULL, watchdog_store);
static struct kobj_attribute kthread_attribute =
	__ATTR(kthread, 0660, NULL, kthread_store);
static struct kobj_attribute mutex_attribute =
	__ATTR(mutex, 0660, NULL, mutex_store);
static struct kobj_attribute tracepoint_attribute =
	__ATTR(tracepoint, 0660, NULL, tracepoint_store);
static struct kobj_attribute rcu_api_attribute =
	__ATTR(rcu_api, 0660, NULL, rcu_api_store);
static struct kobj_attribute srcu_attribute =
	__ATTR(srcu, 0660, NULL, srcu_store);
static struct kobj_attribute might_sleep_attribute =
	__ATTR(might_sleep, 0660, NULL, might_sleep_store);
static struct kobj_attribute wait_event_attribute =
	__ATTR(wait_event, 0660, NULL, might_sleep_store);

DEFINE_TESTER(atomic)
DEFINE_TESTER(io_wait)
DEFINE_TESTER(barrier)

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
