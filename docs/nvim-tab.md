## tab 和 space

tab 会被自动修改为 space 吗? 不会，执行 retab 或者 retab! 来转换。

就是这个插件让我感到恐惧
"tpope/vim-sleuth"

- https://tedlogan.com/techblog3.html
- https://gist.github.com/LunarLambda/4c444238fb364509b72cfb891979f1dd

1. Expandtab : 是否展开 tab 为 space
2. Tabstop : 一个 tab 占用多少个格子
3. Shiftwidth : 当打开自动缩进的时候，

```c
int main(int argc, char *argv[]) { // <- 光标在此处，如果 enter ，下一行
        return 0;
}
```

https://superuser.com/questions/594583/what-does-shiftwidth-do-in-vim-editor : 4. Softtabstop : Number of spaces that a <Tab> counts for while performing editing
operations, like inserting a <Tab> or using <BS>.
https://vi.stackexchange.com/questions/4244/what-is-softtabstop-used-for

5. smarttab
   https://vi.stackexchange.com/questions/34454/how-does-smarttab-actually-works

实不相瞒，感觉还是没有太搞清楚.

- [ ] Softtabstop : 既然是一个 tab 按下去的时候，产生多少个 space 的，那么只有允许 tab expand 的时候才有用吧
- [ ] 让 Softtabstop 和 Shiftwidth 不相等又什么好处吗?

- https://www.reddit.com/r/neovim/comments/17ak2eq/neovim_is_automatically_removing_trailing/

看后面的转义符，本来是对齐的，现在配置之后，似乎是 tab 装换为 space 了，变的不对齐了

```c
#define __WAITQUEUE_INITIALIZER(name, tsk) {					\
	.private	= tsk,							\
	.func		= default_wake_function,				\
	.entry		= { NULL, NULL } }

#define DECLARE_WAITQUEUE(name, tsk)						\
	struct wait_queue_entry name = __WAITQUEUE_INITIALIZER(name, tsk)
```

## 似乎用途不大了
```vim
" 将各种命令的执行结果放到 buffer 中，比如 Redir messages
" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7

" 删除 trailing space 和消除 tab space 混用
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
    retab
endfun
command! TrimWhitespace call TrimWhitespace()
```
