#include <linux/init.h>
#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/delay.h>

//  Define the module metadata.
#define MODULE_NAME "greeter"
MODULE_AUTHOR("Martins3");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A simple kernel module to greet a user");
MODULE_VERSION("0.1");

//  Define the name parameter.
static char *name = "martins3";
module_param(name, charp, S_IRUGO);
MODULE_PARM_DESC(name, "The name to display in /var/log/kern.log");

enum hacking { PR_INFO, WATCH_DOG, KTHREAD, RCU, MUTEX };

#define MAX_THREAD_NUM 256
static struct task_struct *threads[MAX_THREAD_NUM];
static int thread_num;

typedef int thread_function(void *);

static void add_threads(struct task_struct *task)
{
	for (int i = 0; i < thread_num; ++i) {
		if (threads[i] == task) {
			BUG();
		}
	}
	if (thread_num >= MAX_THREAD_NUM) {
		return;
	}
	threads[thread_num] = task;
	thread_num++;
}

void initialize_thread(thread_function func, const char *name, int idx)
{
	struct task_struct *kth;
	kth = kthread_create(func, &idx, "%s", name);
	if (kth != NULL) {
		wake_up_process(kth);
		pr_info("thread %d is running\n", idx);
	} else {
		pr_info("kthread %s could not be created\n", name);
	}
	add_threads(kth);
}

int rcu_x, rcu_y;
int rcu_thread0(void *idx)
{
	int r1, r2;
	int t_id = *(int *)idx;
	while (!kthread_should_stop()) {
		rcu_read_lock();
		r1 = READ_ONCE(rcu_x);
		r2 = READ_ONCE(rcu_y);
		rcu_read_unlock();
		BUG_ON(r1 == 0 && r2 == 1);
	}
	printk(KERN_INFO "thread %d stopped\n", t_id);
	return 0;
}

int rcu_thread1(void *idx)
{
	int t_id = *(int *)idx;

	while (!kthread_should_stop()) {
		WRITE_ONCE(rcu_x, 1);
		synchronize_rcu(); // TODO 将这一行注释掉，并没有什么触发 BUG_ON 直到 softlock up
		WRITE_ONCE(rcu_y, 1);
	}

	printk(KERN_INFO "thread %d stopped\n", t_id);
	return 0;
}

unsigned long counter;
static DEFINE_MUTEX(test_mutex);
#define LOOP_NUM 10000000
int mutex_thread0(void *idx)
{
	for (unsigned long i = 0; i < LOOP_NUM; ++i) {
		mutex_lock(&test_mutex);
		counter++;
		mutex_unlock(&test_mutex);
	}
	pr_info("counter is %lx\n", counter);
	// XXX 如果提前溜走了，那么 kthread_stop 会出问题
	while (!kthread_should_stop())
		msleep(1000); // TODO 有什么一直 sleep 下去的 API 吗?
	return 2;
}

int mutex_thread1(void *idx)
{
	for (unsigned long i = 0; i < LOOP_NUM; ++i) {
		mutex_lock(&test_mutex);
		counter--;
		mutex_unlock(&test_mutex);
	}

	pr_info("counter is %lx\n", counter);
	while (!kthread_should_stop())
		msleep(1000);
	return 1;
}

static void hacking_mutex(void)
{
	initialize_thread(mutex_thread0, "martins3", 0);
	initialize_thread(mutex_thread1, "martins3", 1);
}

static void hacking_rcu(void)
{
	initialize_thread(rcu_thread0, "martins3", 0);
	initialize_thread(rcu_thread1, "martins3", 1);
}

static void stop_threads(void)
{
	int ret;
	for (int i = 0; i < thread_num; ++i) {
		ret = kthread_stop(threads[i]);
		if (ret == -EINTR) {
			pr_info("thread %px never started", threads[i]);
		} else {
			pr_info("thread function return %d", ret);
		}
	}
	thread_num = 0;
}

static int sleep_kthread(void *idx)
{
	int t_id = *(int *)idx;
	int i = 0;
	while (!kthread_should_stop()) {
		msleep(1000);
		printk(KERN_INFO "thread %d \n", i++);
	}
	printk(KERN_INFO "thread %d stopped\n", t_id);
	return 123;
}

static void hacking_kthread(bool start)
{
	if (start) {
		for (int i = 0; i < 2; ++i) {
			initialize_thread(sleep_kthread, "martins3", i);
		}
		printk(KERN_INFO "all of the threads are running\n");
	} else {
		stop_threads();
	}
}

static void hacking_pr_info(void)
{
	// %p 真的烦人，hash 的完全看不懂了
	pr_info("%p", current->mm->pgd);
	pr_info("%px", current->mm->pgd);
	pr_info("%s: module loaded at 0x%p\n", MODULE_NAME, hacking_pr_info);
}

static void hacking_watchdog(void)
{
	bool hard = true;
	if (hard)
		local_irq_disable();

	for (;;) {
	}

	if (hard)
		local_irq_enable();
}

enum hacking h = MUTEX;

static int __init greeter_init(void)
{
	switch (h) {
	case PR_INFO:
		hacking_pr_info();
		break;
	case WATCH_DOG:
		hacking_watchdog();
		break;
	case KTHREAD:
		hacking_kthread(true);
		break;
	case RCU:
		hacking_rcu();
		break;
	case MUTEX:
		hacking_mutex();
		break;
	}

	pr_info("%s: module loaded\n", MODULE_NAME);
	return 0;
}

static void __exit greeter_exit(void)
{
	switch (h) {
	case RCU:
	case KTHREAD:
	case MUTEX:
		hacking_kthread(false);
		break;
	default:
		break;
	}

	pr_info("%s: module unloaded\n", MODULE_NAME);
}

module_init(greeter_init);
module_exit(greeter_exit);
