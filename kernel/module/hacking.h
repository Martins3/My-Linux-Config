#ifndef HACKING_H_PA2UMYTB
#define HACKING_H_PA2UMYTB

#include <linux/module.h>

typedef int thread_function(void *);
struct task_struct * create_thread(const char *name, thread_function func, void * parameter);
void stop_thread(struct task_struct *task);

int simple_seq_init(void);
void simple_seq_fini(void);

int simple_seq_init2(void);
void simple_seq_fini2(void);

int simple_seq_init3(void);
void simple_seq_fini3(void);

int sysfs_init(void);
void sysfs_exit(void);

int my_workqueue_init(void);
void my_workqueue_exit(void);

int sysfs_init(void);
void sysfs_exit(void);

ssize_t mutex_store(struct kobject *kobj, struct kobj_attribute *attr,
			   const char *buf, size_t count);

ssize_t tracepoint_store(struct kobject *kobj, struct kobj_attribute *attr,
		    const char *buf, size_t count);

#endif /* end of include guard: HACKING_H_PA2UMYTB */
