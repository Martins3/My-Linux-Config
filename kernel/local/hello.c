#include <linux/init.h>
#include <linux/module.h>

//  Define the module metadata.
#define MODULE_NAME "greeter"
MODULE_AUTHOR("Martins3");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A simple kernel module to greet a user");
MODULE_VERSION("0.1");

//  Define the name parameter.
static char *name = "Bilbo";
module_param(name, charp, S_IRUGO);
MODULE_PARM_DESC(name, "The name to display in /var/log/kern.log");

static int __init greeter_init(void) {
  pr_info("%s: module loaded at 0x%p\n", MODULE_NAME, greeter_init);
  pr_info("%s: greetings %s\n", MODULE_NAME, name);
  return 0;
}

static void __exit greeter_exit(void) {
  pr_info("%s: goodbye %s\n", MODULE_NAME, name);
  pr_info("%s: module unloaded from 0x%p\n", MODULE_NAME, greeter_exit);
}

int x, y;
void thread0(void) {
  int r1, r2;
  rcu_read_lock();
  r1 = READ_ONCE(x);
  r2 = READ_ONCE(y);
  rcu_read_unlock();
  BUG_ON(r1 == 0 && r2 == 1);
}

void thread1(void) {
  WRITE_ONCE(x, 1);
  synchronize_rcu();
  WRITE_ONCE(y, 1);
}

// @todo 如何让 thread 同时运行 1 分钟

module_init(greeter_init);
module_exit(greeter_exit);
