#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/delay.h>
#include "internal.h"

static void mykmod_work_handler2(struct work_struct *w);
static DECLARE_DELAYED_WORK(mykmod_work2, mykmod_work_handler2);
static struct workqueue_struct *wq;
static void mykmod_work_handler2(struct work_struct *w)
{
	pr_info("mykmod work %u jiffies\n", (unsigned)HZ);
	queue_delayed_work(wq, &mykmod_work2, HZ);
}

static int start_wq2(void)
{
	if (!wq)
		wq = create_singlethread_workqueue("my_workqueue");
	if (wq)
		queue_delayed_work(wq, &mykmod_work2, HZ);

	return 0;
}

static void end_wq2(void)
{
	if (!wq)
		return;
	cancel_delayed_work_sync(&mykmod_work2);
	destroy_workqueue(wq);
}

static void mykmod_work_handler(struct work_struct *w);
static DECLARE_DELAYED_WORK(mykmod_work, mykmod_work_handler);
static void mykmod_work_handler(struct work_struct *w)
{
	pr_info("mykmod work %u jiffies\n", HZ);
	schedule_delayed_work(&mykmod_work, HZ);
}

static void sleep_work(struct work_struct *w);
static DECLARE_DELAYED_WORK(sleep_work_struct, sleep_work);
static void sleep_work(struct work_struct *w)
{
	pr_info("sleep work start");
	/* msleep(5000); */
	pr_info("sleep work finished");
}
static void no_sleep_work(struct work_struct *w);
static DECLARE_DELAYED_WORK(no_sleep_work_struct, no_sleep_work);
static void no_sleep_work(struct work_struct *w)
{
	pr_info("no sleep work finished");
}
// 一个 work 中的函数是不可以动态切换，使用 DECLARE_DELAYED_WORK 或者 INIT_DELAYED_WORK 之后无法修改

static void test_sleep_in_workqueue(void)
{
	if (!wq)
		wq = create_singlethread_workqueue("my_workqueue");
	// TODO
	// 1. 不知道为什么第一个很快结束，但是第二个就是不执行
	// 2. 按道理不应该睡眠，因为会阻碍其他人
	//
	// 是因为 singlethread 的原因吗？
	queue_delayed_work(wq, &sleep_work_struct, HZ);
	queue_delayed_work(wq, &no_sleep_work_struct, 2 * HZ);
}

/*
 * action 1,2 : 将任务挂到 system wq 上
 * action 3,4 : 将任务挂到自己构建的 wq 上
 *
 * INIT_DELAYED_WORK 是 DECLARE_DELAYED_WORK 的动态执行版本
 *
 */
int test_workqueue(int action)
{
	switch (action) {
	case 1:
		schedule_delayed_work(&mykmod_work, HZ);
		break;
	case 2:
		cancel_delayed_work_sync(&mykmod_work);
		break;
	case 3:
		start_wq2();
		break;
	case 4:
		end_wq2();
		break;
	case 5:
		test_sleep_in_workqueue();
		break;
	case 6:
		/* test_dead_loop_in_workqueu(); */
		break;
	}
	return 0;
}
