#include "internal.h"
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/smpboot.h>
#include <linux/percpu.h>
#include <linux/semaphore.h>
#include <linux/delay.h>

/*
 * 理解三个问题:
 * 1. TSO 中的 store/load 乱序具体是指?
 * 2. barrier() 的作用
 *  2.1 如果已经存在了 smp_mb() 还需要使用 barrier() 吗?
 * 3. smp_mb 和 smp_rmb/smp_wmb 的关系时候什么?
 */

#define CONFIG_USE_CPU_BARRIER 1

// 参考: https://github.com/smcdef/memory-reordering/blob/master/ordering.c
static DEFINE_PER_CPU(struct task_struct *, ordering_tasks);
static DEFINE_PER_CPU(struct task_struct *, ordering_tasks2);

static atomic_t count = ATOMIC_INIT(0);
static unsigned int a, b;
static void ordering_thread_fn_cpu3(void)
{
	atomic_inc(&count);
}

static void ordering_thread_fn_cpu4(void)
{
	int temp = atomic_read(&count);

	a = temp;
#ifdef CONFIG_USE_CPU_BARRIER
	smp_wmb();
#else
	/* Prevent compiler reordering. */
	barrier();
#endif
	b = temp;
}

static void ordering_thread_fn_cpu5(void)
{
	unsigned int c, d;

	d = b;
#ifdef CONFIG_USE_CPU_BARRIER
	smp_rmb();
#else
	/* Prevent compiler reordering. */
	barrier();
#endif
	c = a;

	if ((int)(d - c) > 0)
		pr_info("reorders detected, a = %d, b = %d\n", c, d);
}

static int x, y;
static int r1, r2;

static DEFINE_SEMAPHORE(sem_x, 0);
static DEFINE_SEMAPHORE(sem_y, 0);
static DEFINE_SEMAPHORE(sem_end, 0);

static void ordering_thread_fn_cpu0(void)
{
	down(&sem_x);
	x = 1;
#ifdef CONFIG_USE_CPU_BARRIER
	smp_mb();
#else
	/* Prevent compiler reordering. */
	barrier();
#endif
	r1 = y;
	up(&sem_end);
}

static void ordering_thread_fn_cpu1(void)
{
	down(&sem_y);
	y = 1;
#ifdef CONFIG_USE_CPU_BARRIER
	smp_mb();
#else
	/* Prevent compiler reordering. */
	barrier();
#endif
	r2 = x;
	up(&sem_end);
}

/* The Watcher */
static void ordering_thread_fn_cpu2(void)
{
	static unsigned int detected;

	/* Reset x and y. */
	x = 0;
	y = 0;

	up(&sem_x);
	up(&sem_y);

	down(&sem_end);
	down(&sem_end);

	if (r1 == 0 && r2 == 0)
		pr_info("%d reorders detected\n", ++detected);
}

static void ordering_thread_fn(unsigned int cpu)
{
	switch (cpu) {
	case 0:
		ordering_thread_fn_cpu0();
		break;
	case 1:
		ordering_thread_fn_cpu1();
		break;
	case 2:
		ordering_thread_fn_cpu2();
		break;
	default:
		break;
	}
}

static void ordering_thread_fn2(unsigned int cpu)
{
	switch (cpu) {
	case 0:
		ordering_thread_fn_cpu3();
		break;
	case 1:
		ordering_thread_fn_cpu4();
		break;
	case 2:
		ordering_thread_fn_cpu5();
		break;
	default:
		break;
	}
}

static int ordering_should_run(unsigned int cpu)
{
	if (likely(cpu < 3))
		return true;
	return false;
}

static struct smp_hotplug_thread ordering_smp_thread = {
	.store = &ordering_tasks,
	.thread_should_run = ordering_should_run,
	.thread_fn = ordering_thread_fn,
	.thread_comm = "ordering/%u",
};

static struct smp_hotplug_thread ordering_smp_thread2 = {
	.store = &ordering_tasks2,
	.thread_should_run = ordering_should_run,
	.thread_fn = ordering_thread_fn2,
	.thread_comm = "ordering2/%u",
};

static int state = 0;
int test_ordering(int action)
{
	switch (action) {
	case 0:
		if (state & 1)
			smpboot_unregister_percpu_thread(&ordering_smp_thread);
		if (state & 2)
			smpboot_unregister_percpu_thread(&ordering_smp_thread2);
		break;
	case 1:
		if (state & 1)
			return -EINVAL;
		if (smpboot_register_percpu_thread(&ordering_smp_thread))
			return -EINVAL;
		state |= 1;
		break;
	case 2:
		if (state & 2)
			return -EINVAL;
		if (smpboot_register_percpu_thread(&ordering_smp_thread2))
			return -EINVAL;
		state |= 2;
		break;
	}

	return 0;
}
