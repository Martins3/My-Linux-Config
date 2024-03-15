#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/delay.h>
#include "internal.h"

// 一个 work 中的函数是不可以动态切换，使用 DECLARE_DELAYED_WORK 或者 INIT_DELAYED_WORK 之后无法修改
static void mykmod_work_handler2(struct work_struct *w);
static DECLARE_DELAYED_WORK(loop_work_struct, mykmod_work_handler2);
static struct workqueue_struct *wq;
static void mykmod_work_handler2(struct work_struct *w)
{
	pr_info("loop work %u jiffies\n", (unsigned)HZ);
	queue_delayed_work(wq, &loop_work_struct, HZ);
}

static int loop_work(void)
{
	queue_delayed_work(wq, &loop_work_struct, HZ);
	return 0;
}

static void system_work_handler(struct work_struct *w);
static DECLARE_DELAYED_WORK(mykmod_work, system_work_handler);
static void system_work_handler(struct work_struct *w)
{
	pr_info("mykmod work %u jiffies\n", HZ);
	schedule_delayed_work(&mykmod_work, HZ);
}

static void sleep_work(struct work_struct *w);
static DECLARE_DELAYED_WORK(sleep_work_struct, sleep_work);
static void sleep_work(struct work_struct *w)
{
	pr_info("sleep work start\n");
	msleep(10000);
	pr_info("sleep work finished\n");
}
static void no_sleep_work(struct work_struct *w);
static DECLARE_DELAYED_WORK(no_sleep_work_struct, no_sleep_work);
static void no_sleep_work(struct work_struct *w)
{
	pr_info("no sleep work finished\n");
}

static void test_max_active_in_workqueue(void)
{
	queue_delayed_work(wq, &sleep_work_struct, HZ);
	queue_delayed_work(wq, &no_sleep_work_struct, 2 * HZ);
}

// 并没有什么神奇的事情发生，简简单单的触发 softlock 而已
static void dead_loop_work(struct work_struct *w);
static DECLARE_DELAYED_WORK(dead_loop_work_struct, dead_loop_work);
static void dead_loop_work(struct work_struct *w)
{
	for (;;)
		cpu_relax();
}
static void test_dead_loop_in_workqueue(void)
{
	queue_delayed_work(wq, &dead_loop_work_struct, 1 * HZ);
}

static void clear_workqueue(void)
{
	if (!wq)
		return;
	cancel_delayed_work_sync(&loop_work_struct);
	destroy_workqueue(wq);
}

static void test_flush(void)
{
	queue_delayed_work(wq, &sleep_work_struct, HZ);
}

/*
 * action 1,2 : 将任务挂到 system wq 上
 * action 3,4 : 将任务挂到自己构建的 wq 上
 *
 * 1. INIT_DELAYED_WORK 是 DECLARE_DELAYED_WORK 的动态执行版本
 * 2. queue_delayed_work 和 queue_work 实际上区别不大，只是加入队列前会睡眠一小会
 * 3. max_active : 如果等于 1 ，那么即使第一个 work 睡眠了，第二个 work 也无法执行
 * 4. flush_workqueue : 等待 wq 中的工作做完，在 flush_workqueue 开始之后的任务不等待
 *
 */
int test_workqueue(int action)
{
	if (action == 0) {
		clear_workqueue();
		return 0;
	}
	if (!wq)
		wq = alloc_workqueue("my_workqueue", WQ_UNBOUND | WQ_SYSFS, 1);

	switch (action) {
	case 1:
		schedule_delayed_work(&mykmod_work, HZ);
		break;
	case 2:
		cancel_delayed_work_sync(&mykmod_work);
		break;
	case 3:
		loop_work();
		break;
	case 5:
		test_max_active_in_workqueue();
		break;
	case 6:
		test_dead_loop_in_workqueue();
		break;
	case 7:
		test_flush();
		break;
	case 8:
		if (wq)
			flush_workqueue(wq);
		else
			return 1;
		break;
	case 9:
		flush_delayed_work(&sleep_work_struct);
		break;
	}
	return 0;
}
