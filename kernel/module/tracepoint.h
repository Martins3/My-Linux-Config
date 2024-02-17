#if !defined(_TRACE_HACK_H) || defined(TRACE_HEADER_MULTI_READ)
#define _TRACE_HACK_H

#include <linux/tracepoint.h>
#include <linux/trace_events.h>

#undef TRACE_SYSTEM
#define TRACE_SYSTEM hack

TRACE_EVENT(hack_eventname,

	    TP_PROTO(int count),

	    TP_ARGS(count),

	    TP_STRUCT__entry(__field(u32, count)),

	    TP_fast_assign(__entry->count = count;),

	    TP_printk("action=%lu ", (unsigned long)__entry->count));
#endif /* _TRACE_HACK_H */

#undef TRACE_INCLUDE_PATH
// 好吧，这样写的确很恶心，但是已经花了 17 分钟了
#define TRACE_INCLUDE_PATH /home/martins3/.dotfiles/kernel/module/
#undef TRACE_INCLUDE_FILE
#define TRACE_INCLUDE_FILE tracepoint

/* This part must be outside protection */
#include <trace/define_trace.h>
