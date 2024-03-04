# 测试内容

## 快捷参考
1. https://github.com/torvalds/linux/blob/master/samples/kobject/kobject-example.c
2. https://github.com/sysprog21/lkmpg

## seq file
参考:
1. https://stackoverflow.com/questions/25399112/how-to-use-a-seq-file-in-linux-kernel-modules

## 触发一下 rcu cpu stall 的 bug

Documentation/RCU/ 中包含了 stallwarn 的分析

## workqueue

## rcu
rcu_read_unlock_bh

fd_install 中使用的 rcu_read_lock_sched 如何操作的

### 分析下 rcu_dereference_protected 的使用
rcu_dereference_raw，存在一个问题，在 crash 中，如何访问一个 rcu 保护的指针，如果指定想要访问的指针是什么?

RCU_INIT_POINTER
RCU_POINTER_INITIALIZER
```txt
/**
 * RCU_INIT_POINTER() - initialize an RCU protected pointer
 * @p: The pointer to be initialized.
 * @v: The value to initialized the pointer to.
 *
 * Initialize an RCU-protected pointer in special cases where readers
 * do not need ordering constraints on the CPU or the compiler.  These
 * special cases are:
 *
 * 1.	This use of RCU_INIT_POINTER() is NULLing out the pointer *or*
 * 2.	The caller has taken whatever steps are required to prevent
 *	RCU readers from concurrently accessing this pointer *or*
 * 3.	The referenced data structure has already been exposed to
 *	readers either at compile time or via rcu_assign_pointer() *and*
 *
 *	a.	You have not made *any* reader-visible changes to
 *		this structure since then *or*
 *	b.	It is OK for readers accessing this structure from its
 *		new location to see the old state of the structure.  (For
 *		example, the changes were to statistical counters or to
 *		other state where exact synchronization is not required.)
 *
 * Failure to follow these rules governing use of RCU_INIT_POINTER() will
 * result in impossible-to-diagnose memory corruption.  As in the structures
 * will look OK in crash dumps, but any concurrent RCU readers might
 * see pre-initialized values of the referenced data structure.  So
 * please be very careful how you use RCU_INIT_POINTER()!!!
 *
 * If you are creating an RCU-protected linked structure that is accessed
 * by a single external-to-structure RCU-protected pointer, then you may
 * use RCU_INIT_POINTER() to initialize the internal RCU-protected
 * pointers, but you must use rcu_assign_pointer() to initialize the
 * external-to-structure pointer *after* you have completely initialized
 * the reader-accessible portions of the linked structure.
 *
 * Note that unlike rcu_assign_pointer(), RCU_INIT_POINTER() provides no
 * ordering guarantees for either the CPU or the compiler.
 */
#define RCU_INIT_POINTER(p, v) \
	do { \
		rcu_check_sparse(p, __rcu); \
		WRITE_ONCE(p, RCU_INITIALIZER(v)); \
	} while (0)

/**
 * RCU_POINTER_INITIALIZER() - statically initialize an RCU protected pointer
 * @p: The pointer to be initialized.
 * @v: The value to initialized the pointer to.
 *
 * GCC-style initialization for an RCU-protected pointer in a structure field.
 */
#define RCU_POINTER_INITIALIZER(p, v) \
		.p = RCU_INITIALIZER(v)
```

## watchdog 测试中，softlock 只要进行死循环就可以了，
但是不是会存在时钟中断吗? 但是

## config/sh/bpftrace.sh
中应该直接使用 bcc 工具就可以了， bpftrace 的作用应该是方便的写代码
，应该重新阅读下用 bpftrace 写代码。

## completion 和 wait event 有区别吗?
https://kernelnewbies.kernelnewbies.narkive.com/lLxcBrgc/wait-event-interruptible-vs-wait-for-completion-interruptible


## 应该测试下所谓的 lockless 算法的性能
https://lwn.net/Articles/844224/

## 增加一个 virtio-device 测试下效果

Documentation/driver-api/virtio/writing_virtio_drivers.rst

参考这个例子:
drivers/virtio/virtio_balloon.c

- [ ] 实现 virtio queue 密集中断，echo 123 > /sys/kernel/dummy/echo 有难度?

## dummy 中每次都会输出这个，合理吗
```txt
[martins3:virtio_dummy_set_status:106] 0x55a2eec34030
[martins3:virtio_dummy_set_status:106] 0x55a2eec34030
[martins3:virtio_dummy_set_status:106] 0x55a2eec34030
```
但是加载其的 virtio 设备没有这个输出吧

## 测试内容
2. 有办法实现 virtio-dummy 中实现异步的中断注入吗?
3. rcu_read_unlock 可以在中断上下文中使用吗?

4. 为什么现在 disable bh 的时候，等价于 rcu_read_lock
  - RCU 的 read lock 到底在做什么来着
  - RCU write 不需要 lock ?
  - 话说，为什么存在这种等价。如果在中断上下文中，岂不是更加是等价于。

## [ ] 给 qemu 增加代码来测试 qemu 用户态的 RCU 才可以
