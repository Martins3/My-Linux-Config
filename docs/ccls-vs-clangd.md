# ccls vs clangd : 2023 年版本

先说结论，采用 ccls


## ccls 的问题
1. coc.nvim 会显示 index 多少，这个计数是错的，而且正好是两倍的关系；
2. ccls 在 nixos 很容易需要重新索引，如果机器性能不行，对于 Linux 之类的项目，一般需要很长时间；
3. ccls 的高亮依赖额外的插件；
4. ccls 在 coc.nvim 需要额外的配置参数。

![](https://user-images.githubusercontent.com/16731244/215423644-d462a7c8-f691-4137-aac4-875d449608ee.png)

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

## 都存在的问题
索引 ARM 如果失败，可以在 compile_commands.json 中将 `-mabi=lp64` 删除。

## clangd 做的好的地方
1. 自动切换
2. https://clangd.llvm.org/design/remote-index : 看上去不错，但是没有尝试

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
