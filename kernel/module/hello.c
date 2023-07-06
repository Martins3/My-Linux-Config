#include "hacking.h"
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/kthread.h>
#include <linux/module.h>
#include <linux/semaphore.h>

//  Define the module metadata.
#define MODULE_NAME "greeter"
MODULE_AUTHOR("Martins3");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("A simple kernel module to greet a user");
MODULE_VERSION("0.1");

//  Define the name parameter.
static char *name = "martins3";
module_param(name, charp, S_IRUGO);
MODULE_PARM_DESC(name, "The name to display in /var/log/kern.log");

#define MAX_THREAD_NUM 256
static struct task_struct *threads[MAX_THREAD_NUM];
static int thread_num;

typedef int thread_function(void *);

static void add_threads(struct task_struct *task) {
  for (int i = 0; i < thread_num; ++i) {
    if (threads[i] == task) {
      BUG();
    }
  }
  if (thread_num >= MAX_THREAD_NUM) {
    return;
  }
  threads[thread_num] = task;
  thread_num++;
}

static void stop_threads(void) {
  int ret;
  for (int i = 0; i < thread_num; ++i) {
    /**
     * 如果在 kthread 中 stop 自己，测试出来过这个问题:
     * [   31.770761] loop 305183 times, found 5
     * [   31.770965] BUG: unable to handle page fault for address:
     * ffffffffc000255c [   31.771304] #PF: supervisor instruction fetch in
     * kernel mode [   31.771576] #PF: error_code(0x0010) - not-present page
     * [   31.771829] PGD 3043067 P4D 3043067 PUD 3045067 PMD 103ae9067 PTE 0
     * [   31.772132] Oops: 0010 [#1] PREEMPT SMP NOPTI
     * [   31.772350] CPU: 7 PID: 1646 Comm: martins3 Tainted: G
     * O       6.4.0-rc1-00138-gd4d58949a6ea-dirty #260
     */
    if (threads[i] == current) {
      continue;
    }
    ret = kthread_stop(threads[i]);
    if (ret == -EINTR) {
      pr_info("thread %px never started", threads[i]);
    } else {
      pr_info("thread function return %d", ret);
    }
  }
  thread_num = 0;
}

static int sleep_kthread(void *idx) {
  int t_id = *(int *)idx;
  int i = 0;
  while (!kthread_should_stop()) {
    msleep(1000);
    printk(KERN_INFO "thread %d \n", i++);
  }
  printk(KERN_INFO "thread %d stopped\n", t_id);
  return 123;
}

void initialize_thread(thread_function func, const char *name, int idx) {
  struct task_struct *kth;
  kth = kthread_create(func, &idx, "%s", name);
  if (kth != NULL) {
    wake_up_process(kth);
    pr_info("thread %d is running\n", idx);
  } else {
    pr_info("kthread %s could not be created\n", name);
  }
  add_threads(kth);
}

static void hacking_kthread(bool start) {
  if (start) {
    for (int i = 0; i < 2; ++i) {
      initialize_thread(sleep_kthread, "martins3", i);
    }
    printk(KERN_INFO "all of the threads are running\n");
  } else {
    stop_threads();
  }
}

static unsigned int mm2_a, mm2_b;
static unsigned int mm2_x, mm2_y;
static struct semaphore sem_x;
static struct semaphore sem_y;
static struct semaphore sem_end;

static int ordering_thread_fn2_cpu0(void *idx) {
  static unsigned int detected;
  static unsigned long loop;
  while (!kthread_should_stop()) {
    loop++;

    mm2_x = 0;
    mm2_y = 0;

    up(&sem_x);
    up(&sem_y);

    down(&sem_end);
    down(&sem_end);

    if (mm2_a == 0 && mm2_b == 0)
      pr_info("%d reorders detected\n", ++detected);

    if (detected >= 100) {
      // 平均 10 次触发一次，不知道有没有更好的方法来触发
      pr_info("loop %ld times, found %d\n", loop, detected);
      stop_threads();
      return 0;
    }
  }
  return 0;
}

static int ordering_thread_fn2_cpu1(void *idx) {
  while (!kthread_should_stop()) {
    down(&sem_x);
    mm2_x = 1;
#ifdef CONFIG_USE_CPU_BARRIER
    smp_wmb();
#else
    /* Prevent compiler reordering. */
    barrier();
#endif
    mm2_a = mm2_y;
    up(&sem_end);
  }
  return 0;
}

static int ordering_thread_fn2_cpu2(void *idx) {
  while (!kthread_should_stop()) {
    down(&sem_y);
    mm2_y = 1;
#ifdef CONFIG_USE_CPU_BARRIER
    smp_rmb();
#else
    /* Prevent compiler reordering. */
    barrier();
#endif
    mm2_b = mm2_x;
    up(&sem_end);
  }
  return 0;
}

static void hacking_memory_model_2(void) {
  sema_init(&sem_x, 0);
  sema_init(&sem_y, 0);
  sema_init(&sem_end, 0);
  initialize_thread(ordering_thread_fn2_cpu0, "martins3", 0);
  initialize_thread(ordering_thread_fn2_cpu1, "martins3", 0);
  initialize_thread(ordering_thread_fn2_cpu2, "martins3", 0);
}

static atomic_t count = ATOMIC_INIT(0);
static unsigned int a, b;

static int ordering_thread_fn_cpu0(void *idx) {
  while (!kthread_should_stop()) {
    atomic_inc(&count);
  }

  pr_info("counter :  %d\n", atomic_read(&count));
  return 0;
}

static int ordering_thread_fn_cpu1(void *idx) {
  pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
  while (!kthread_should_stop()) {
    int temp = atomic_read(&count);

    a = temp;
#ifdef CONFIG_USE_CPU_BARRIER
    smp_wmb();
#else
    /* Prevent compiler reordering. */
    barrier();
#endif
    b = temp;
  }
  return 0;
}

static int ordering_thread_fn_cpu2(void *idx) {
  pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
  while (!kthread_should_stop()) {
    unsigned int c, d;

    d = b;
#ifdef CONFIG_USE_CPU_BARRIER
    smp_rmb();
#else
    /* Prevent compiler reordering. */
    barrier();
#endif
    c = a;

    if ((int)(d - c) > 0)
      pr_info("reorders detected, a = %d, b = %d\n", c, d);
  }
  return 0;
}

static void hacking_memory_model_1(void) {
  initialize_thread(ordering_thread_fn_cpu0, "martins3", 0);
  initialize_thread(ordering_thread_fn_cpu1, "martins3", 0);
  initialize_thread(ordering_thread_fn_cpu2, "martins3", 0);
}

int rcu_x, rcu_y;
int rcu_thread0(void *idx) {
  int r1, r2;
  int t_id = *(int *)idx;
  while (!kthread_should_stop()) {
    rcu_read_lock();
    r1 = READ_ONCE(rcu_x);
    r2 = READ_ONCE(rcu_y);
    rcu_read_unlock();
    BUG_ON(r1 == 0 && r2 == 1);
  }
  printk(KERN_INFO "thread %d stopped\n", t_id);
  return 0;
}

int rcu_thread1(void *idx) {
  int t_id = *(int *)idx;

  while (!kthread_should_stop()) {
    WRITE_ONCE(rcu_x, 1);
    synchronize_rcu(); // TODO 将这一行注释掉，并没有什么触发 BUG_ON 直到
                       // softlock up
    WRITE_ONCE(rcu_y, 1);
  }

  printk(KERN_INFO "thread %d stopped\n", t_id);
  return 0;
}

unsigned long counter;
static DEFINE_MUTEX(test_mutex);
#define LOOP_NUM 10000000
int mutex_thread0(void *idx) {
  for (unsigned long i = 0; i < LOOP_NUM; ++i) {
    mutex_lock(&test_mutex);
    counter++;
    mutex_unlock(&test_mutex);
  }
  pr_info("counter is %lx\n", counter);
  // XXX 如果提前溜走了，那么 kthread_stop 会出问题
  while (!kthread_should_stop())
    msleep(1000); // TODO 有什么一直 sleep 下去的 API 吗?
  return 2;
}

int mutex_thread1(void *idx) {
  for (unsigned long i = 0; i < LOOP_NUM; ++i) {
    mutex_lock(&test_mutex);
    counter--;
    mutex_unlock(&test_mutex);
  }

  pr_info("counter is %lx\n", counter);
  while (!kthread_should_stop())
    msleep(1000);
  return 1;
}

static void hacking_mutex(void) {
  initialize_thread(mutex_thread0, "martins3", 0);
  initialize_thread(mutex_thread1, "martins3", 1);
}

static void hacking_rcu(void) {
  initialize_thread(rcu_thread0, "martins3", 0);
  initialize_thread(rcu_thread1, "martins3", 1);
}

static void hacking_pr_info(void) {
  // %p 真的烦人，hash 的完全看不懂了
  pr_info("%p", current->mm->pgd);
  pr_info("%px", current->mm->pgd);
  pr_info("%s: module loaded at 0x%p\n", MODULE_NAME, hacking_pr_info);
}

static void hacking_watchdog(void) {
  bool hard = false;
  if (hard)
    local_irq_disable();

  for (;;) {
    // TODO
    // 1. 如果中断屏蔽了，这个就没用了
    // 2. 此外，此时的 insmod martins3.ko 是无法被 Ctrl C 掉的
    cond_resched();
  }

  if (hard)
    local_irq_enable();
}

// TODO 做成参数
enum hacking h = SYS_FS;

static int __init greeter_init(void) {
  int error = 0;
  switch (h) {
  case PR_INFO:
    hacking_pr_info();
    break;
  case WATCH_DOG:
    hacking_watchdog();
    break;
  case KTHREAD:
    hacking_kthread(true);
    break;
  case RCU:
    hacking_rcu();
    break;
  case MUTEX:
    hacking_mutex();
    break;
  case MEMORY_MODEL_1:
    hacking_memory_model_1();
    break;
  case MEMORY_MODEL_2:
    hacking_memory_model_2();
    break;
  case SEQ_FILE_1:
    simple_seq_init();
    break;
  case SEQ_FILE_2:
    simple_seq_init2();
    break;
  case SYS_FS:
    error = sysfs_init();
    break;
  }

  if (error)
    return error;

  pr_info("%s: module loaded\n", MODULE_NAME);
  return 0;
}

static void __exit greeter_exit(void) {
  switch (h) {
  case RCU:
  case KTHREAD:
  case MUTEX:
  case MEMORY_MODEL_1:
    hacking_kthread(false);
    break;
  case SEQ_FILE_1:
    simple_seq_fini();
    break;
  case SEQ_FILE_2:
    simple_seq_fini2();
    break;
  case SYS_FS:
    sysfs_exit();
    break;
  default:
    break;
  }

  pr_info("%s: module unloaded\n", MODULE_NAME);
}

module_init(greeter_init);
module_exit(greeter_exit);
