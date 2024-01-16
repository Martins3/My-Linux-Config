#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/page_ref.h>
#include <linux/proc_fs.h>
#include <linux/sched.h>
#include <linux/uaccess.h>
#include <linux/version.h>
#include <linux/workqueue.h>
#include <linux/mmap_lock.h>
#include <linux/delay.h>

static int pid = 0;

static ssize_t martins3_show(struct kobject *kobj, struct kobj_attribute *attr,
                             char *buf) {
  return sprintf(buf, "%d\n", pid);
}

static ssize_t martins3_store(struct kobject *kobj, struct kobj_attribute *attr,
                              char *buf, size_t count) {
  int err;
  struct task_struct *p;
  err = kstrtou32(buf, 10, &pid);
  if (err)
    return -EINVAL;

  p = get_pid_task(find_get_pid(pid), PIDTYPE_PID);
  if (!p)
    return -EINVAL;

  mmap_write_lock(p->mm);
  msleep(30 * 1000);
  mmap_write_unlock(p->mm);

  return count;
}

static struct kobj_attribute myvariable_attribute =
    __ATTR(knob, 0644, martins3_show, (void *)martins3_store);

static struct kobject *martins3_kobj;
int sysfs_martins3_init(void);
int sysfs_martins3_init(void) {
  int error = 0;
  if (martins3_kobj != NULL)
    return 0;

  pr_info("martins3: initialised\n");

  // 创建 /sys/kernel/martins3
  martins3_kobj = kobject_create_and_add("test_mutex", kernel_kobj);
  if (!martins3_kobj)
    return -ENOMEM;

  error = sysfs_create_file(martins3_kobj, &myvariable_attribute.attr);
  if (error) {
    pr_info("failed to create the myvariable file "
            "in /sys/kernel/martins3\n");
  }

  return error;
}

static int __init mod_init(void) {
  sysfs_martins3_init();
  return 0;
}

static void __exit mod_exit(void) {}

module_init(mod_init);
module_exit(mod_exit);
MODULE_LICENSE("GPL");
