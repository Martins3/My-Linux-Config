#include "hacking.h"
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

// static unsigned int mm2_a, mm2_b;
// static unsigned int mm2_x, mm2_y;
// static struct semaphore sem_x;
// static struct semaphore sem_y;
// static struct semaphore sem_end;
//
// static int ordering_thread_fn2_cpu0(void *idx)
// {
// 	static unsigned int detected;
// 	static unsigned long loop;
// 	while (!kthread_should_stop()) {
// 		loop++;
//
// 		mm2_x = 0;
// 		mm2_y = 0;
//
// 		up(&sem_x);
// 		up(&sem_y);
//
// 		down(&sem_end);
// 		down(&sem_end);
//
// 		if (mm2_a == 0 && mm2_b == 0)
// 			pr_info("%d reorders detected\n", ++detected);
//
// 		if (detected >= 100) {
// 			// 平均 10 次触发一次，不知道有没有更好的方法来触发
// 			pr_info("loop %ld times, found %d\n", loop, detected);
// 			stop_threads();
// 			return 0;
// 		}
// 	}
// 	return 0;
// }
//
// static int ordering_thread_fn2_cpu1(void *idx)
// {
// 	while (!kthread_should_stop()) {
// 		down(&sem_x);
// 		mm2_x = 1;
// #ifdef CONFIG_USE_CPU_BARRIER
// 		smp_wmb();
// #else
// 		/* Prevent compiler reordering. */
// 		barrier();
// #endif
// 		mm2_a = mm2_y;
// 		up(&sem_end);
// 	}
// 	return 0;
// }
//
// static int ordering_thread_fn2_cpu2(void *idx)
// {
// 	while (!kthread_should_stop()) {
// 		down(&sem_y);
// 		mm2_y = 1;
// #ifdef CONFIG_USE_CPU_BARRIER
// 		smp_rmb();
// #else
// 		/* Prevent compiler reordering. */
// 		barrier();
// #endif
// 		mm2_b = mm2_x;
// 		up(&sem_end);
// 	}
// 	return 0;
// }
//
// static void hacking_memory_model_2(void)
// {
// 	sema_init(&sem_x, 0);
// 	sema_init(&sem_y, 0);
// 	sema_init(&sem_end, 0);
// 	initialize_thread(ordering_thread_fn2_cpu0, "martins3", 0);
// 	initialize_thread(ordering_thread_fn2_cpu1, "martins3", 0);
// 	initialize_thread(ordering_thread_fn2_cpu2, "martins3", 0);
// }
//
// static atomic_t count = ATOMIC_INIT(0);
// static unsigned int a, b;
//
// static int ordering_thread_fn_cpu0(void *idx)
// {
// 	while (!kthread_should_stop()) {
// 		atomic_inc(&count);
// 	}
//
// 	pr_info("counter :  %d\n", atomic_read(&count));
// 	return 0;
// }
//
// static int ordering_thread_fn_cpu1(void *idx)
// {
// 	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
// 	while (!kthread_should_stop()) {
// 		int temp = atomic_read(&count);
//
// 		a = temp;
// #ifdef CONFIG_USE_CPU_BARRIER
// 		smp_wmb();
// #else
// 		/* Prevent compiler reordering. */
// 		barrier();
// #endif
// 		b = temp;
// 	}
// 	return 0;
// }
//
// static int ordering_thread_fn_cpu2(void *idx)
// {
// 	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
// 	while (!kthread_should_stop()) {
// 		unsigned int c, d;
//
// 		d = b;
// #ifdef CONFIG_USE_CPU_BARRIER
// 		smp_rmb();
// #else
// 		/* Prevent compiler reordering. */
// 		barrier();
// #endif
// 		c = a;
//
// 		if ((int)(d - c) > 0)
// 			pr_info("reorders detected, a = %d, b = %d\n", c, d);
// 	}
// 	return 0;
// }
//
// static void hacking_memory_model_1(void)
// {
// 	initialize_thread(ordering_thread_fn_cpu0, "martins3", 0);
// 	initialize_thread(ordering_thread_fn_cpu1, "martins3", 0);
// 	initialize_thread(ordering_thread_fn_cpu2, "martins3", 0);
// }
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
	int hard;
	bool disable_irq = false;
	bool check_signal = false;

	ret = kstrtoint(buf, 10, &hard);
	if (ret < 0)
		return ret;

	disable_irq = hard % 10;
	check_signal = (hard / 10) % 10;
	pr_info("watchdog : %s %s \n", check_signal ? "check_signal" : "",
		disable_irq ? "disable_irq" : "");

	if (disable_irq)
		local_irq_disable();

	for (;;) {
		// 无论是否屏蔽中断，signal_pending 都是可以接受到的，原因 bash 父进程传递的
		// 无论是否屏蔽，ctrl-c 都是无法打断当前进程的
		if (check_signal && signal_pending(current))
			break;

		cond_resched();
	}

	if (disable_irq)
		local_irq_enable();

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
