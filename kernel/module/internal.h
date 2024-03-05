#ifndef HACKING_H_PA2UMYTB
#define HACKING_H_PA2UMYTB

#include <linux/module.h>

typedef int thread_function(void *);
struct task_struct *create_thread(const char *name, thread_function func,
				  void *parameter);
void stop_thread(struct task_struct *task);

int simple_seq_init(void);
void simple_seq_fini(void);

int simple_seq_init2(void);
void simple_seq_fini2(void);

int simple_seq_init3(void);
void simple_seq_fini3(void);

int my_workqueue_init(void);
void my_workqueue_exit(void);

#define DECLARE_TESTER(_prefix) int test_##_prefix(int action);

#define DEFINE_TESTER(_prefix)                                        \
	static ssize_t _prefix##_store(struct kobject *kobj,          \
				       struct kobj_attribute *attr,   \
				       const char *buf, size_t count) \
	{                                                             \
		int ret;                                              \
		int action;                                           \
		ret = kstrtoint(buf, 10, &action);                    \
		if (ret < 0)                                          \
			return ret;                                   \
		pr_info("%s : action = %d \n", __FUNCTION__, action); \
		ret = test_##_prefix(action);                         \
		if (ret)                                              \
			return ret;                                   \
		return count;                                         \
	}                                                             \
                                                                      \
	static struct kobj_attribute _prefix##_attribute =            \
		__ATTR(_prefix, 0660, NULL, _prefix##_store);

DECLARE_TESTER(watchdog)
DECLARE_TESTER(kthread)
DECLARE_TESTER(mutex)
DECLARE_TESTER(tracepoint)
DECLARE_TESTER(rcu_api)
DECLARE_TESTER(srcu)
DECLARE_TESTER(might_sleep)
DECLARE_TESTER(wait_event)
DECLARE_TESTER(atomic)
DECLARE_TESTER(io_wait)
DECLARE_TESTER(barrier)
DECLARE_TESTER(rwsem)
DECLARE_TESTER(complete)
DECLARE_TESTER(percpu_rwsem)
DECLARE_TESTER(preempt)

#endif /* end of include guard: HACKING_H_PA2UMYTB */
