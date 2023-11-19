# 测试内容

- [ ] rcu
- [ ] all kinds of locking
- [ ] https://github.com/smcdef/memory-reordering/blob/master/ordering.c
- [ ] include/linux/semaphore.h
  - https://lwn.net/Articles/928026/
- [ ] 测试 interruptable 和 uninterrpable 的
- [ ] 测试等待 io 也是计入到 load 中的

## seq file
参考:
1. https://stackoverflow.com/questions/25399112/how-to-use-a-seq-file-in-linux-kernel-modules
2. https://github.com/sysprog21/lkmpg

## cpu_relax vs cond_resched


## 持有 mutex 睡眠


## 这个补充一下
```c
trace_printk("martins3 like %s\n", "ftrace");
```

```c
pr_info("[martins3:%s:%d] rtm always abort %d\n", __FUNCTION__, __LINE__, cpu_khz);
```

## 触发一下类似这种报错
```txt
[19892.185338] "echo 0 > /proc/sys/kernel/hung__task__timeout__secs" disables this message.
[19892.185363] ps              D    0 83180  84135 0x00000080
[19892.185366] Call Trace:
[19892.185375]  ? __schedule+0x24f/0x650
[19892.185377]  schedule+0x2f/0xa0
[19892.185379]  rwsem__down__read__slowpath+0x3e5/0x520
[19892.185382]  __access__remote__vm+0x5a/0x2d0
[19892.185386]  proc__pid__cmdline__read+0x1a6/0x350
[19892.185389]  vfs__read+0x91/0x140
[19892.185391]  ksys__read+0x4f/0xb0
[19892.185394]  do__syscall__64+0x5b/0x1a0
[19892.185397]  entry__SYSCALL__64__after__hwframe+0x65/0xca
[19892.185399] RIP: 0033:0x7f0a8dc9b7e0
[19892.185405] Code: Bad RIP value.
[19892.185406] RSP: 002b:00007ffc3c1a1a38 EFLAGS: 00000246 ORIG__RAX: 0000000000000000
[19892.185408] RAX: ffffffffffffffda RBX: 00007f0a8e53d010 RCX: 00007f0a8dc9b7e0
[19892.185409] RDX: 0000000000020000 RSI: 00007f0a8e53d010 RDI: 0000000000000006
[19892.185409] RBP: 0000000000020000 R08: 00007f0a8dbfa988 R09: 0000000000000013
[19892.185410] R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
[19892.185411] R13: 00007f0a8e53d010 R14: 0000000000000000 R15: 0000000000000006
```

## 触发一下 rcu cpu stall 的 bug


## 对于一般的内核模块替换
make path/to/name.ko -j32


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

## 还是用 sysfs 来整理这些代码吧
除了 procfs 外吧
