# vim 的高级话题

## 黑魔法

- [`ctrl i`实际上等同于 tab 的](https://github.com/neoclide/coc.nvim/issues/1089), 重新映射为 `<Space>` `i`， 🤡 用了 5 年 vim 才知道这个。
- [vim 中 `<cr>` 和 `<enter>` 有什么区别](https://www.reddit.com/r/vim/comments/u2989c/what_is_the_difference_between_cr_and_enter/)
  - 没有区别，除了拼写不同
- [使用 sudo 保存一个文件](https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work)
  - `w !sudo tee %`
- [如何删除每一行的第一个字符](https://stackoverflow.com/questions/1568115/delete-first-word-of-each-line)
  - `:%norm dw`

- [ ] `:options` 检查所有的 options
- `set!` : 检查修改过的项目

## augroup

https://vi.stackexchange.com/questions/9455/why-should-i-use-augroup

:augroup


## 调试插件的 bug

为了制作一个最小的复现环境，

使用 .dotfiles/nvim/debug/switch.sh 来来回

为 .dotfiles/nvim/debug/init.lua 和本配置

## 踩坑
1. 一个错误的配置

自动关闭 vim 如果 window 中只有一个 filetree
```txt
https://github.com/kyazdani42/nvim-tree.lua
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
```
应该是这个导致 session 无法正常工作的

2. 强制升级方法
cd $HOME/.local/share/nvim/lazy/ && rm -rf hydra.nvim
找到 nvim/lazy-lock.json ，将其中 hydra.nvim 那个删掉

## tree-sitter

- https://siraben.dev/2022/03/01/tree-sitter.html
- https://siraben.dev/2022/03/22/tree-sitter-linter.html

## 参考

- https://blog.antoyo.xyz/vim-tips
- [ ] https://news.ycombinator.com/item?id=36312027
- https://m4xshen.dev/posts/vim-command-workflow/


## 尝试下
- https://github.com/abecodes/tabout.nvim

## 问题

- 极为细节的问题，但是折腾下应该还是可解的

  - ,s 的时候，正好匹配的那个总是不是第一个，检查一下 telescope
  - https://www.trickster.dev/post/vim-is-touch-typing-on-steroids/ : 从后往前阅读

2. [gcov](https://marketplace.visualstudio.com/items?itemName=JacquesLucke.gcov-viewer)


## 意义不大
- https://github.com/2KAbhishek/termim.nvim
- https://github.com/ibhagwan/smartyank.nvim
- https://github.com/chrishrb/gx.nvim : 我原来用的啥实现 gx 的来着

## Markdown 和 bash 的文件类型相关的参数的确需要重构了下了

https://github.com/nvim-neorocks/nvim-best-practices

## 如果可以在 terminal 中连续的两个 esc ，就推出 terminal ，那个是极好的

## https://github.com/danielfalk/smart-open.nvim
依赖于 sqlite ，提供了方法 sqlite 在 nixos 中的方法，但是没有
这个项目自己似乎凉了

类似的功能，但是似乎也凉了
https://github.com/cbochs/grapple.nvim
  - 和 nvim-telescope/telescope-frecency.nvim 对比下，真的很慢

## 用用这个软件
https://github.com/mpv-player/mpv

https://vim-racer.com/

https://github.com/sindrets/diffview.nvim : 尝试下



## [ ] tree-sitter 和 vim 的各种操作的语义

text obj 的含义

```lua
  {
    "cshuaimin/ssr.nvim",
    module = "ssr",
    vim.keymap.set({ "n", "x" }, "<leader>r", function()
      require("ssr").open()
    end),
  }, -- 结构化查询和替换

  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
  },
```

## [ ] 看看这些都如何用
```lua
'm4xshen/hardtime.nvim'
"azabiong/vim-highlighter", -- 高亮多个搜索内容
"dstein64/vim-startuptime", -- 分析 nvim 启动时间
'wakatime/vim-wakatime' -- 代码时间统计
"tpope/vim-repeat", -- 更加强大的 `.`
"mg979/vim-visual-multi", -- 同时编辑多个位置
"AckslD/nvim-neoclip.lua", -- 保存 macro
```

## [ ] 如何处理
导航栏中，对于
```txt
			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
```

会显示出来:
```txt
  󰊕  __compiletime_assert_1139
```

看看主流配置是如何使用导航栏的

## [ ]  重新配置一下 lsp
https://lsp-zero.netlify.app/docs/language-server-configuration.html

## 又是一堆 neovim 的小插件
- https://www.reddit.com/r/neovim/comments/1gl5uaz/snacksnvim_a_collection_of_small_qol_plugins_for/
  - https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
    - 他这里封装了 terminal，不好用

## 看看这个
- https://www.reddit.com/r/neovim/comments/1gk0phq/tinkering_with_neovim/


## [ ] Markdown 中，list 不会自动补全了
从 before branch ，忽然发现:
- fafa
- enter 之后没有自动补全了 - 了，难道 cmp 配置错误了

## 花费无数时间，最后才可以知道的
- https://github.com/anuvyklack/hydra.nvim 是会触发 nvim 的 bug
- https://github.com/nvimtools/hydra.nvim

## [ ] 检查这个文档，发现其实英语的自动检查是有希望的
- https://github.com/williamboman/mason-lspconfig.nvim

harper_ls

## [ ] 解决 nixos 中这个问题
https://github.com/aitjcize/cppman

快捷键也是不好用的，应该类似 `K`

而且 c 语言中的 man 可不可以有类似的搞法

## [ ] 似乎我的 markdown 的 format 无法正常工作了

## [ ]  orgmode 用起来？
https://beorg.app/orgmode/letsgetgoing/

## [ ] 这个经常不准
lua require('barbecue.ui').navigate(-1)

似乎都是不准的，难受
./barbecue.diff

```c
void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
{
	if (!map)
		return;

	if (!map->hva)
		return;

	if (map->page != KVM_UNMAPPED_PAGE)
		kunmap(map->page);
#ifdef CONFIG_HAS_IOMEM
	else
		memunmap(map->hva);
#endif

	if (dirty)
		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);

	kvm_release_pfn(map->pfn, dirty);

	map->hva = NULL;
	map->page = NULL;
}
```
使用 tree-sitter 的模式，如果从下面 gj，最后会跳到 else 那里。
看来是 tree sitter 的 bug 了。

而且无法跳到结构体的开始位置

## [ ] 这个还是不错的
- https://github.com/glepnir/nvim

## [ ] zellij 的问题更多了
1. nvim 无法在其中拷贝
2. ui 总是在闪烁啊

## [ ] nvim 放着不动就会有 5% 的 CPU 使用率
这不对吧

- https://github.com/t-troebst/perfanno.nvim : perf 展示到 nvim 中

## 还是有必要看看的
很多东西过时了，但是还是有很多可以参考的
https://danielmiessler.com/study/vim

## 被废弃的方法
### 输入法自动切换

在 vim 中使用中文输入法，如果打字完成，进入 normal 模式，使用 gg 想要移动到文件的第一行，结果发现 gg 被中文输入法截断了。
所以需要一个插件可以在进入 normal 的模式的时候中文输入法切走。

可以使用两套方案，但是原理都是相同的，

- 方案 1:
  - 使用 [fcitx.nvim](https://github.com/h-hg/fcitx.nvim)，其代码相当简洁优雅。
  - 如果是在 MacOS 上，需要在系统中安装 [fcitx-remote-for-osx](https://github.com/xcodebuild/fcitx-remote-for-osx) 来切换输入法。
- 方案 2:
  - [coc-imselect](https://github.com/neoclide/coc-imselect) 自动包含了 fcitx-remote-for-osx 的功能，无论是在 MacOS 上还是 Linux 上都是相同的。

当我在切换到 MacOS 的时候，发现输入法的自动切换不能正常工作，最后通过这个 [commit](https://github.com/Martins3/fcitx.nvim/commit/f1c97b6821a76263a84addfe5c6fdb4178e90ca9) 进行了修复。

## 很难受，在 linux 中现在不可以用了，真的有点抽象了
- https://www.cnblogs.com/sxrhhh/p/18234652/neovim-copy-anywhere

## 插件
https://github.com/LintaoAmons/bookmarks.nvim

https://github.com/OXY2DEV/markview.nvim

https://github.com/bash-lsp/bash-language-server

https://news.ycombinator.com/item?id=42674116
https://news.ycombinator.com/item?id=40179194
https://m4xshen.dev/posts/vim-command-workflow


## https://github.com/yetone/avante.nvim
配合 deepseek 用用看看效果，不过可以继续等等
也看看这个 : https://github.com/olimorris/codecompanion.nvim
类似的这个效果有吗? https://github.com/continuedev/continue


https://github.com/prochri/telescope-all-recent.nvim

cline

沉浸式翻译

## 话说，有没有类似 mason-lspconfig 来解决字体安装的

## 这个工具可以理解下
https://github.com/analysis-tools-dev/static-analysis

## 配置一下这个
https://github.com/zbirenbaum/copilot.lua

## 有趣
https://github.com/Chenyu-otf/chenyuluoyan_thin

## 把这个安排上
https://github.com/huacnlee/autocorrect

## 可以尝试一下，一个新的 task runner
overseer.nvim

https://github.com/aaronik/treewalker.nvim


## 一个新的 c lsp ，保持关注吧
https://github.com/clice-project/clice

## neovim lsp  相关
:checkhealth lsp

https://gpanders.com/blog/whats-new-in-neovim-0-11/#lspa

## vim-matchup 会引入严重的性能问题

```txt
  "andymass/vim-matchup", -- 高亮匹配的元素，例如 #if 和 #endif
```

但是，现在 #if 和 #endif 的确是没有办法识别了

## neovim 迭代极快，问题极多
https://news.ycombinator.com/item?id=45121915

## julia evans 切换到 helix 的体验
https://news.ycombinator.com/item?id=45539609

https://news.ycombinator.com/item?id=45559076

## 这个是可以解决我们的问题的
rachartier/tiny-inline-diagnostic.nvim

不过用起来有点 bug 

## 现在 nvim 到底使用什么翻译还是一个小问题

## tree-sitter 类似的？
https://ast-grep.github.io/
