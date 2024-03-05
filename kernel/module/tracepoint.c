#include "internal.h"
#include <linux/module.h>

#define CREATE_TRACE_POINTS
#include "tracepoint.h"

// https://lwn.net/Articles/379903/
int test_tracepoint(int action)
{
	trace_printk("hello\n");

	// tracepoint 的函数可以多次调用
	trace_hack_eventname(action);
	trace_hack_eventname(action + 1);

	return 0;
}
