# 2023 年对比一下 ccls 和 clangd

先说结论，ccls 更好。

网上冲浪的时候，感觉有一个普遍的想法，那就是认为 clangd 更好，例如
1. [最终，我看向了 clangd](https://zhuanlan.zhihu.com/p/364518020)

我主要看 QEMU 和 Linux 两个项目，尤其是 Linux ，我之所以认为 ccls 更好是因为
我特别重视索引的准确程度，ccls 几乎没有出错，但是 clangd 问题很多，而且还出现了
功能回退的现象。

从项目名称上，大家开始的时候会觉得 clangd 才是 LLVM 的官方项目，而 ccls 是一个个人项目，但是实际上，
ccls 的作者 MaskRay 的水平远远高于 clangd 的 maintainer ，他在 LLVM 的累积提交的 commit
超过 3000 个，他的 blog : https://maskray.me/blog/ 水平很高，如果是编译方向的同学，我建议仔细阅读。
对于 ccls 的代码质量不需要有任何质疑。

## clangd 的问题
以内核为例:

### 无法全局搜索宏
索引 NULL_COMPOUND_DTOR 找不到
```c
compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
	[NULL_COMPOUND_DTOR] = NULL,
	[COMPOUND_PAGE_DTOR] = free_compound_page,
#ifdef CONFIG_HUGETLB_PAGE
	[HUGETLB_PAGE_DTOR] = free_huge_page,
#endif
#ifdef CONFIG_TRANSPARENT_HUGEPAGE
	[TRANSHUGE_PAGE_DTOR] = free_transhuge_page,
#endif
};
```

### 一些地方颜色渲染不对
这是 clangd 的结果:
![](https://user-images.githubusercontent.com/16731244/199185065-4f18db07-e8bb-4bc2-b3e1-316fe9edcba1.png)

这是 ccls 的结果:
![](https://user-images.githubusercontent.com/16731244/219828512-db2bbf9d-3e74-42cb-b7aa-b58a62f331d7.png)

### 无法理解和宏重名的结构体成员

```c
struct mem_cgroup {

	union {
		struct page_counter swap;	/* v2 only */
		struct page_counter memsw;	/* v1 only */
	};
```
我发现这里的 swap 总是被理解为:
```c
/**
 * swap - swap values of @a and @b
 * @a: first value
 * @b: second value
 */
#define swap(a, b) \
	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
```
### clangd 无法理解 gcc 的参数，导致内核项目头上总是存在大量报错
可以参考 https://stackoverflow.com/questions/70819007/can-not-use-clangd-to-read-linux-kernel-code 解决

### 复杂的 macro 无法跳转
例如:
```c
static inline unsigned long __raw_spin_lock_irqsave(raw_spinlock_t *lock)
{
	unsigned long flags;

	local_irq_save(flags);
	preempt_disable();
	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
	return flags;
}
```
`spin_acquire` and `LOCK_CONTENDED`

类似的 `ioremap` 这个函数也无法正常跳转。

### clangd 在 telescope 中搜索的时候两侧不能有空格

必须去掉那些空格，否则搜索内容为空，而 ccls 可以容忍

### clangd 无法理解系统中的参数
例如在内核的代码中创建一个 hello.c ，ccls 可以提供内核的代码要求
![](https://user-images.githubusercontent.com/16731244/215423433-cc4295a9-fbe3-431e-ac8f-119a8fd28d46.png)

### 默认版本 clangd 在 ARM 中不是默认采用 CPU 的数量来索引的
具体版本 clangd 13
解决办法:
```json
  "clangd.arguments": ["-j=20"]
```
升级 clangd
```json
  "clangd.path": "/home/martins3/core/LLVM/build/bin/clangd"
```

### 有的函数搜索不到
该问题 clangd 13 不存在，升级到 clangd 14 就出现了，之后一直存在。

例如 `__populate_section_memmap` 是搜索不到的。

### 在 ARM 上展示奇怪的警告
![](https://user-images.githubusercontent.com/16731244/198576471-d35773af-0ef8-4528-8fb6-59fb5bfd2dd5.png)

### clangd 的头文件自动添加不精确
时不时引入错误的头文件，让编译失败。

## ccls 的问题
当然 ccls 现在我用起来也是有点小问题的:

2. ccls 在 nixos 很容易需要重新索引，如果机器性能不行，对于 Linux 之类的项目，一般需要很长时间；
3. ccls 的高亮依赖额外的插件；

![](https://user-images.githubusercontent.com/16731244/215423644-d462a7c8-f691-4137-aac4-875d449608ee.png)


## 都存在的问题
索引 ARM 如果失败，可以在 compile_commands.json 中将 `-mabi=lp64` 删除。

## clangd 做的好的地方
1. 自动切换
2. https://clangd.llvm.org/design/remote-index : 看上去不错，但是没有尝试

## 更多参考
- https://github.com/MaskRay/ccls/issues/880

<script src="https://giscus.app/client.js"
        data-repo="Martins3/My-Linux-Config"
        data-repo-id="MDEwOlJlcG9zaXRvcnkyMTUwMDkyMDU="
        data-category="General"
        data-category-id="MDE4OkRpc2N1c3Npb25DYXRlZ29yeTMyODc0NjA5"
        data-mapping="pathname"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="en"
        crossorigin="anonymous"
        async>
</script>

本站所有文章转发 **CSDN** 将按侵权追究法律责任，其它情况随意。
