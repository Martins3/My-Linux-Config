# vim 的高级话题

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
https://superuser.com/questions/594583/what-does-shiftwidth-do-in-vim-editor :
4. Softtabstop : Number of spaces that a <Tab> counts for while performing editing
	operations, like inserting a <Tab> or using <BS>.
https://vi.stackexchange.com/questions/4244/what-is-softtabstop-used-for

5. smarttab
https://vi.stackexchange.com/questions/34454/how-does-smarttab-actually-works

实不相瞒，感觉还是没有太搞清楚.
- [ ] Softtabstop : 既然是一个 tab 按下去的时候，产生多少个 space 的，那么只有允许 tab expand 的时候才有用吧
- [ ] 让 Softtabstop 和 Shiftwidth 不相等又什么好处吗?

## 黑魔法
- [`ctrl i`实际上等同于 tab 的](https://github.com/neoclide/coc.nvim/issues/1089), 重新映射为 `<Space>` `i`， 🤡 用了 5 年 vim 才知道这个。
- [vim 中 `<cr>` 和 `<enter>` 有什么区别](https://www.reddit.com/r/vim/comments/u2989c/what_is_the_difference_between_cr_and_enter/)
  - 没有区别，除了拼写不同
- [使用 sudo 保存一个文件](https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
  - `w !sudo tee %`
- [如何删除每一行的第一个字符](https://stackoverflow.com/questions/1568115/delete-first-word-of-each-line)
  - `:%norm dw`

## 调试插件的 bug
为了制作一个最小的复现环境，

使用 .dotfiles/nvim/debug/switch.sh 来来回

为 .dotfiles/nvim/debug/init.lua 和本配置

## 参考
- https://blog.antoyo.xyz/vim-tips


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
