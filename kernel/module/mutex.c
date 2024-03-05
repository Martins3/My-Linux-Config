#include "internal.h"
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/kthread.h>
#include <linux/module.h>
#include <linux/semaphore.h>

unsigned long counter;
static DEFINE_MUTEX(test_mutex_hi);
#define LOOP_NUM 10000000

static struct task_struct *holder;

static int mutex_lock_it(void *idx)
{
	mutex_lock(&test_mutex_hi);
	for (int i = 0; i < 1000; i++) {
		pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
		msleep(1000);
	}
	mutex_unlock(&test_mutex_hi);
	return 1;
}

static void test_mutex_lock(void)
{
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	mutex_lock(&test_mutex_hi);
	mutex_unlock(&test_mutex_hi);
}

static void test_mutex_lock_killable(void)
{
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	// mutex_lock_interrupt 类似的，ctrl-c 都可以杀掉
	if (mutex_lock_killable(&test_mutex_hi))
		pr_info("lock killed");
	mutex_unlock(&test_mutex_hi);
}

int test_mutex(int action)
{
	switch (action) {
	case 0:
		if (!holder)
			holder = create_thread("holder", mutex_lock_it, NULL);
		break;
	case 1:
		test_mutex_lock();
		break;
	case 2:
		test_mutex_lock_killable();
		break;
	}
	return 0;
}
