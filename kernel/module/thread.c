#include "hacking.h"
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/kthread.h>
#include <linux/module.h>
#include <linux/semaphore.h>

struct kthread_func {
	thread_function *func;
	void *parameter;
};

// 访问 count 应该是并发才对
static int count;

static int kthread_sleep(void *idx)
{
	struct kthread_func *func = idx;
	while (!kthread_should_stop()) {
		int ret = func->func(func->parameter);
		if (ret)
			return ret;
	}
	return 123;
}

void stop_thread(struct task_struct *task)
{
	if (task == NULL)
		return;
	int ret = kthread_stop(task);
	if (ret == -EINTR)
		BUG();
	// 这里存在对于 kthread_func 的内存泄露，将就一下吧
}

struct task_struct *create_thread(const char *name, thread_function func,
				  void *parameter)
{
	struct task_struct *kth;
	struct kthread_func *f =
		kmalloc(sizeof(struct kthread_func), GFP_KERNEL);
	if (f == NULL)
		return NULL;

	f->func = func;
	f->parameter = parameter;
	kth = kthread_create(kthread_sleep, f, "%s-%d", name, count++);
	if (kth != NULL)
		wake_up_process(kth);
	else
		kfree(kth);
	return kth;
}
