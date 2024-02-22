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

## 触发一下 rcu cpu stall 的 bug

## 测试 percpu_ref_kill 的使用

## workqueue

## rcu
rcu_read_unlock_bh

fd_install 中使用的 rcu_read_lock_sched 如何操作的

## atomic 的 api 比想象的更加复杂啊
atomic_dec_and_raw_lock(atomic, lock)
