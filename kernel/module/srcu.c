#include "internal.h"
#include <linux/module.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/kthread.h>
#include <linux/rcupdate.h>
#include <linux/delay.h>

static struct task_struct *reader;
static struct task_struct *writer;
DEFINE_STATIC_SRCU(srcu);

static int srcu_reader_thread(void *idx)
{
	int srcu_idx;
	srcu_idx = srcu_read_lock(&srcu);
	msleep(5000);
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	srcu_read_unlock(&srcu, srcu_idx);
	return 0;
}

static int srcu_writer_thread(void *idx)
{
	synchronize_srcu(&srcu);
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	return 0;
}

static int rcu_reader_thread(void *idx)
{
	rcu_read_lock();
	// msleep(1000); // 的确，如果在 rcu_read_lock 中 schdule 的话，会出现问题的
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	rcu_read_unlock();
	msleep(400);
	return 0;
}

static int rcu_writer_thread(void *idx)
{
	synchronize_rcu();
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	msleep(1000);
	return 0;
}

static void srcu_test(void)
{
	reader = create_thread("reader", srcu_reader_thread, NULL);
	writer = create_thread("writer", srcu_writer_thread, NULL);
}

static void rcu_test(void)
{
	reader = create_thread("reader", rcu_reader_thread, NULL);
	writer = create_thread("writer", rcu_writer_thread, NULL);
}

int test_srcu(int action)
{
	if (reader) {
		stop_thread(reader);
		stop_thread(writer);
	}

	if (action)
		rcu_test();
	else
		srcu_test();
	return 0;
}
