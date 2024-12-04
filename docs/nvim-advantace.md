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

## 参考

- https://blog.antoyo.xyz/vim-tips
- [ ] https://news.ycombinator.com/item?id=36312027
- https://m4xshen.dev/posts/vim-command-workflow/

## .h 默认启用的是 cpp ，但是 cpp 中没有 once

- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/c/c.json

- https://www.reddit.com/r/neovim/comments/13yw98e/how_can_i_switch_the_local_input_method_in_vim_on/

## [ ] 此外，struct-> 补全的时候，会出现在第一个字母上

- 是 ccls 的问题吗?

## 插件开发

https://zignar.net/2023/06/10/debugging-lua-in-neovim/


https://github.com/ibhagwan/smartyank.nvim

## 需要解决下闪退的问题
当然，是 session 的原因，但是，我非常怀疑和 nvim tree 有关的

## 尝试下
https://github.com/abecodes/tabout.nvim
https://github.com/YaroSpace/lua-console.nvim

## 问题

- 极为细节的问题，但是折腾下应该还是可解的

  - ,s 的时候，正好匹配的那个总是不是第一个，检查一下 telescope
  - https://www.trickster.dev/post/vim-is-touch-typing-on-steroids/ : 从后往前阅读

  2. [gcov](https://marketplace.visualstudio.com/items?itemName=JacquesLucke.gcov-viewer)

## wl-copy 似乎有点扰乱了系统


## 需要将 bash 整理下
https://unix.stackexchange.com/questions/65932/how-to-get-the-first-word-of-a-string

## 也许替换掉

  { "SmiteshP/nvim-navic" },     -- 在 winbar 展示当前的路径
  { "utilyre/barbecue.nvim" },

https://nvimdev.github.io/lspsaga/outline/

## 尝试下
https://github.com/2KAbhishek/termim.nvim

## python 的代码补全消失了

## 的确比较有趣
https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bufremove.md#features

其实可以更新下

## Markdown 和 bash 的文件类型相关的参数的确需要重构了下了

https://github.com/nvim-neorocks/nvim-best-practices

## 如果可以在 terminal 中连续的两个 esc ，就推出 terminal ，那个是极好的

## sqlite ，好麻烦啊!
https://github.com/danielfalk/smart-open.nvim 依赖于 sqlite ，nixos 上无法解决

## 看看这个
https://github.com/chrishrb/gx.nvim

## 用用这个软件
https://github.com/mpv-player/mpv

https://vim-racer.com/

https://github.com/sindrets/diffview.nvim : 尝试下

https://github.com/cbochs/grapple.nvim
  - 和 nvim-telescope/telescope-frecency.nvim 对比下，真的很慢


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

这个应该是用点用的:
https://github.com/ptdewey/pendulum-nvim

没办法正常使用，如果可以用的话，那么是极好的

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
- enter 之后没有自动补全了，难道 cmp 配置错误了

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

## [ ] bug : bash 的跳转不正常了
shellcheck 的问题吗?

## [ ] zellij 的问题更多了

1. nvim 无法在其中拷贝
2. ui 总是在闪烁啊

## [ ] 不知道为什么，这里很多地方都没有办法跳转
- https://github.com/danobi/vmtest

例如这里的 remove_file ，而且被高亮为红色了:
```rs
impl Drop for Qemu {
    fn drop(&mut self) {
        let _ = fs::remove_file(self.qga_sock.as_path());
        let _ = fs::remove_file(self.qmp_sock.as_path());
        let _ = fs::remove_file(self.command_sock.as_path());
    }
}
```

## [ ] nvim 放着不动就会有 5% 的 CPU 使用率
这不对吧

## [ ] 这个有趣的
https://github.com/nvzone/menu

https://github.com/t-troebst/perfanno.nvim

## [ ] 如何跳到屏幕的开始

## 升级方法
cd $HOME/.local/share/nvim/lazy/ && rm -rf hydra.nvim

找到 nvim/lazy-lock.json ，将其中 hydra.nvim 那个删掉

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

https://github.com/LintaoAmons/bookmarks.nvim
