# 测试内容

# 代办
- [ ] all kinds of locking
- [ ] https://github.com/smcdef/memory-reordering/blob/master/ordering.c
- [ ] include/linux/semaphore.h
  - https://lwn.net/Articles/928026/
- [ ] 测试 interruptable 和 uninterrpable 的
- [ ] 测试等待 io 也是计入到 load 中的
- [ ] watchdog 中无法测试出来 softlock 的效果

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

## workqueue

## might_sleep 的作用是什么 ?
