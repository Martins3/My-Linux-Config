#include <asm/tsc.h>
#include <linux/kernel.h>
#include <linux/module.h>

static int vermagic_init(void) {
  pr_info("[huxueshi:%s:%d] %d\n", __FUNCTION__, __LINE__, cpu_khz);
  trace_printk("martins3 like %s\n", "ftrace");
  return 0;
}

void aperfmperf_get_khz(int cpu) {
  // @todo 测试一下这个代码
  /* smp_call_function_single(cpu, aperfmperf_snapshot_khz, NULL, wait); */
}

static void vermagic_exit(void) {}

module_init(vermagic_init) module_exit(vermagic_exit) MODULE_LICENSE("GPL");
