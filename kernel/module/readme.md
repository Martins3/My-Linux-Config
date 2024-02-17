# 测试内容

## watchdog
1. softlock 无法触发出来

# 代办
- [ ] rcu
- [ ] all kinds of locking
- [ ] https://github.com/smcdef/memory-reordering/blob/master/ordering.c
- [ ] include/linux/semaphore.h
  - https://lwn.net/Articles/928026/
- [ ] 测试 interruptable 和 uninterrpable 的
- [ ] 测试等待 io 也是计入到 load 中的

## 快捷参考
1. https://github.com/torvalds/linux/blob/master/samples/kobject/kobject-example.c
2. https://github.com/sysprog21/lkmpg

## seq file
参考:
1. https://stackoverflow.com/questions/25399112/how-to-use-a-seq-file-in-linux-kernel-modules

## cpu_relax vs cond_resched

## 触发一下 rcu cpu stall 的 bug

## wait_event
- blk_queue_enter 中，wait_event 前面居然有一个 smp_read
配合这个使用:
- wake_up_all

## percpu_ref_kill


## 将 rcu 用起来再说
https://lwn.net/Articles/777036/

- synchronize_rcu()  : 等待 rcu grace 时间结束
- synchronize_rcu_expedited() ： 强制结束 rcu grace 时间，感觉一般都是在 subsystem 关闭的时候
- call_rcu

## workqueue
