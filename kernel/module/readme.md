# 测试内容

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

## 当前的上下文无法测试

## atomic 的 api 比想象的更加复杂啊
https://docs.kernel.org/core-api/wrappers/atomic_t.html

1. atomic_dec_and_raw_lock(atomic, lock)
2. 例如 refcount_t
Reference count (but please see refcount_t):

  atomic_add_unless(), atomic_inc_not_zero()
  atomic_sub_and_test(), atomic_dec_and_test()

3. 例如 barrier 的代码:

Barriers:

  smp_mb__{before,after}_atomic()

4. 更多的 barrier 代码

Non-RMW ops:

  atomic_read(), atomic_set()
  atomic_read_acquire(), atomic_set_release()
