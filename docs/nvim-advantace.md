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

- https://www.reddit.com/r/neovim/comments/17ak2eq/neovim_is_automatically_removing_trailing/

### 从远程 server 上复制粘贴

在远程 server 复制，内容会进入到远程 server 的系统剪切板中，但是你往往是想复制本地的电脑的剪切板中。

使用插件 [ojroques/vim-oscyank](https://github.com/ojroques/vim-oscyank) 可以让在远程 server 的拷贝的内容直接进入到本地的系统剪切板上。

增加上如下命令到 init.vim ，可以实现自动拷贝到本地电脑中
```vim
" "让远程的 server 内容拷贝到系统剪切板中，具体参考 https://github.com/ojroques/vim-oscyank
autocmd TextYankPost *
    \ if v:event.operator is 'y' && v:event.regname is '+' |
    \ execute 'OSCYankRegister +' |
    \ endif

autocmd TextYankPost *
    \ if v:event.operator is 'd' && v:event.regname is '+' |
    \ execute 'OSCYankRegister +' |
    \ endif
```

使用方法，选中的内容之后，nvim 的命令行中执行: `OSCYankVisual`

原理上参考:
- https://news.ycombinator.com/item?id=32037489
- https://github.com/ojroques/vim-oscyank/issues/24

需要注意的是，这个功能依赖于 terminal 支持 OSC52 ，例如 Windows Terminal 就不支持，如果想在 Windows 中
连接远程的 nvim，可以将 terminal 切换为 wezterm 等支持 OSC52 功能的终端。

不知道发生了什么，我现在无需安装任何插件，在 vim 中的任何操作都是直接从服务器拷贝到本地的:
这个原理太神奇了，现在看来只有两个小问题:
1. gx 打开本地的浏览器(需求比较小)
2. 输入法的自动切换

- 这是一个突破口
  - https://www.reddit.com/r/neovim/comments/13yw98e/how_can_i_switch_the_local_input_method_in_vim_on/

似乎有的机器可以这样，有的不可以，没太搞清楚差别。
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

## tree-sitter
- https://siraben.dev/2022/03/01/tree-sitter.html
- https://siraben.dev/2022/03/22/tree-sitter-linter.html

## 插件开发
https://github.com/nvim-neotest/neotest

## 参考
- https://blog.antoyo.xyz/vim-tips
- [ ] https://news.ycombinator.com/item?id=36312027
- https://m4xshen.dev/posts/vim-command-workflow/


## 待处理
- nvim/lua/usr/nvim-treesitter.lua 全部都是警告

- https://github.com/otavioschwanck/arrow.nvim 使用

## 保存的时候，会自动将 tailspace 删除掉
即使是 debug mode :
https://github.com/cappyzawa/trim.nvim : 也许靠这个维持生活?

## 问题
- 极为细节的问题，但是折腾下应该还是可解的
  - ,s 的时候，正好匹配的那个总是不是第一个，检查一下 telescope
  - 集成 https://github.com/crate-ci/typos
  - https://github.com/ranjithshegde/ccls.nvim : treesitter 跳转到函数头还是不精准
  - https://github.com/uga-rosa/cmp-dictionary/wiki/Examples-of-usage : 补全中没有 10K words 这种数据来源
  - https://github.com/koalaman/shellcheck/issues/1284
  - https://www.trickster.dev/post/vim-is-touch-typing-on-steroids/ : 从后往前阅读
  - leap.nvim 似乎特殊处理过 f/F 以及 t/T 的
  - [neodim](https://github.com/zbirenbaum/neodim) : 等待升级到 0.10
  - https://github.com/ryanmsnyder/toggleterm-manager.nvim : 替换下 term
- nvim 有待解决的问题，不是一时半会可以解决的:
  1. 编辑远程代码: 最佳状态是 vscode 的那种模式，收集一些替代，虽然都差的很远
     - https://github.com/jamestthompson3/nvim-remote-containers
     - https://github.com/OscarCreator/rsync.nvim
      - 但是 rsync 时间戳似乎维护的有问题，经常遇到这个问题: make: warning:  Clock skew detected.  Your build may be incomplete.
  2. [gcov](https://marketplace.visualstudio.com/items?itemName=JacquesLucke.gcov-viewer)

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
