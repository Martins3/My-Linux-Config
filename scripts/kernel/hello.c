#include <linux/module.h>
#include <linux/kernel.h>
#include <asm/tsc.h>

static int vermagic_init(void)
{
  pr_info("[huxueshi:%s:%d] %d\n", __FUNCTION__, __LINE__, cpu_khz);
  trace_printk("martins3 like %s\n", "ftrace");
  return 0;
}

static void vermagic_exit(void) {}

module_init(vermagic_init)
module_exit(vermagic_exit)
MODULE_LICENSE("GPL");
