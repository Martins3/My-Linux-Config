#include "hacking.h"
#include <linux/module.h>

#define CREATE_TRACE_POINTS
#include "tracepoint.h"

ssize_t tracepoint_store(struct kobject *kobj, struct kobj_attribute *attr,
			 const char *buf, size_t count)
{
	int ret;
	int val;
	ret = kstrtoint(buf, 10, &val);
	if (ret < 0)
		return ret;

  trace_printk("hello\n");

	trace_hack_eventname(val);

	trace_hack_eventname(val + 1);

	return count;
}
