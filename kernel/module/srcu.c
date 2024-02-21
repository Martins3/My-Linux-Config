#include "hacking.h"
#include <linux/module.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/kthread.h>
#include <linux/rcupdate.h>
#include <linux/delay.h>

static struct task_struct *reader;
static struct task_struct *writer;

static int reader_thread(void *idx)

{
	for (int i = 0; i < 1000; i++) {
	}
	return 1;
}

static int writer_thread(void *idx)
{
	for (int i = 0; i < 1000; i++) {

	}
	return 1;
}

ssize_t srcu_store(struct kobject *kobj, struct kobj_attribute *attr,
		   const char *buf, size_t count)
{
	int ret;
	int val;
	ret = kstrtoint(buf, 10, &val);
	if (ret < 0)
		return ret;

	if (reader)
		return -EINVAL;

	reader = create_thread("reader", reader_thread, NULL);
	writer = create_thread("reader", writer_thread, NULL);

	return count;
}
