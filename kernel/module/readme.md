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

## 现在没有办法测试中断上下文，有办法实现吗?


## watchdog 测试中，softlock 只要进行死循环就可以了，
但是不是会存在时钟中断吗?

## 测试使用下
up_write
