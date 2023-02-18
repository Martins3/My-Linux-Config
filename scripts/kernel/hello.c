#include <linux/module.h>
#include <linux/kernel.h>

static int vermagic_init(void)
{
  return 0;
}

static void vermagic_exit(void) {}

module_init(vermagic_init)
module_exit(vermagic_exit)
MODULE_LICENSE("GPL");
