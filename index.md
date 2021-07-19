# 2021 年 vim 的 C/C++ 配置


- [前言](#前言)
- [背景](#背景)
- [关于如何入门 vim](#关于如何入门-vim)
- [终极解决方案: lsp](#终极解决方案-lsp)
- [丝般顺滑的 async](#丝般顺滑的-async)
- [为什么使用 SpaceVim](#为什么使用-spacevim)
- [为什么使用 coc.nvim](#为什么使用-cocnvim)
- [安装](#安装)
- [以 Linux 内核为例](#以-linux-内核为例)
- [基本操作](#基本操作)
    - [symbol search](#symbol-search)
    - [string search](#string-search)
    - [file tree](#file-tree)
    - [window](#window)
    - [buffer](#buffer)
    - [navigate](#navigate)
    - [define reference](#define-reference)
    - [comment](#comment)
    - [documentation](#documentation)
    - [snippet](#snippet)
    - [git](#git)
    - [format](#format)
    - [rename](#rename)
    - [debug](#debug)
    - [terminal](#terminal)
- [扩展](#扩展)
    - [基于SpaceVim的扩展 以Latex为例子](#基于spacevim的扩展-以latex为例子)
    - [基于coc.nvim的扩展 以Python为例](#基于cocnvim的扩展-以python为例)
- [本配置源代码解释](#本配置源代码解释)
- [vim 的小技巧](#vim-的小技巧)
- [其他的一些资源](#其他的一些资源)
    - [学习](#学习)
    - [主题](#主题)
    - [框架](#框架)
    - [衍生](#衍生)
- [ref](#ref)


[![asciicast](https://asciinema.org/a/gzqB5Kqc0Ke3Kdds304JBEYyC.svg)](https://asciinema.org/a/gzqB5Kqc0Ke3Kdds304JBEYyC)

## 前言
首先，任何问题,  欢迎[issue](https://github.com/Martins3/My-Linux-config/issues?q=is%3Aissue)。

本文的目标观众:
1. vim 新手
2. 正在使用 cscope[^1] / ctags / gtags / nerdtree / YouCompleteMe 的 vimer
3. 不了解 Language Server Protocal[^5] (下简称 lsp ) 和 async 的 vimer

我想说的是，vim 正在飞速进步 ，拥抱 lsp 和 async 等新特性，vim 一定的比你想象的酷炫和高效。

## 背景 
我平时主要写 C/C++, 配置是参考 use_vim_as_ide[^9] 写的，
在处理几个文件的小项目时候，比如刷刷 leetcode 之类的，还是勉强够用，但是等到处理 Linux 内核这种超大型的项目的时候，
我发现 gtags / cscope 这种符号索引工具，YouCompleteMe 类似的补全静态检查的工具很难配置，nerdtree 在打开一个含有很多目录的文件的时候，
整个 vim 都会变卡。

曾经为了在 vim 中间写 C/C++，你需要安装 ctags 生成索引，需要安装 ctags 的 vim 插件在 vim 中间使用 ctags，需要安装自动更新索引数据库的插件，安装 YCM 实现静态检查，你还会发现 ctags 存在好几个版本，安装不对，对应的插件也没有办法正常工作。
最最让人崩溃的是，那一天你忽然想使用 vim 写一个新的语言，比如 Java，类似的操作你又需要重新走一遍，而且还要手动映射快捷键，来保证这些快捷键不会互相冲突。

## 关于如何入门 vim
其实关于 vim 的基本知识教程有很多，这里我推荐两个网站
1. [openvim](https://www.openvim.com/tutorial.html) : 交互式的学习 vim
2. [vim check sheet](https://vim.rtorr.com/lang/zh_cn) : vim 通用快捷键清单

如果完全没有基础，建议使用 openvim 打牢基础之后，然后就直接将 vim 用于实战中间，因为这些快捷键都是肌肉记忆，无非多熟悉一下而已。当你知道 hikl 之类的操作之后
使用 vim check sheet 是强化补充的，不要指望一次全部背下来，也没有必要全部记住，一次学几个，学最能提高你工作效率的。

vim 的学习曲线陡峭主要就是在最开始的 hjkl 这些快捷键的记忆，但是最多几天，之后就学习就非常平缓了，无非是装装插件，重新映射一下快捷键之类的事情。

虽然我使用了很长时间的 vim，但是两个东西我依旧觉得非常坑，那就是退出和复制。关于 vim 如何退出，闹出很多笑话，比如有人创建一个仓库[^6]用于收集各种退出的方法。stackoverflow 的报告说，其帮助了一百万人次如何退出 vim 。

1. 退出: 我使用 `:xa` 退出vim。 `x` 表示保存并且关闭buffer，`a`表示运用于所有的。有时候出现意外关闭vim，再次打开文件可以出现警告，解决办法是 : 首先利用.swp 文件进行恢复，然后手动清理 `~/.cache/SpaceVim/swap` .swp 文件。
    - 至于为什么存在这个 `.swp` 文件以及如何关闭这个选项，可以参考这里。
2. `,` `y` 和 `,` `p` 实现复制粘贴。

## 终极解决方案: lsp
lsp 是微软开发 VSCode 提出的，其定义了一套标准编辑器和 language server 之间的规范。
1. 不同的语言需要不同的 Language Server，比如C/C++ 需要 ccls[^12], Rust 语言采用 rust-analyzer[^15], 官方列举了很多 Language server[^13]。
2. 不同的编辑按照 lsp 的规范和 language server 通信

他们大致的关系如下, 通过统一的接口，大大的减少了重复开发，lsp 定义的查找引用，定义，格式化代码功能只需要安装对应的 language server 支持就是开箱即用，再也无需从各种插件哪里东拼西凑这些功能。

```
 +------------------------+    +-----------------------+
 |                        |    |                       |
 |      Editor            | <--+   Language Server     |
 |                        |    |                       |
 +------------------------+    +-----------------------+
 |     Atom               |    |                       |
 |     Emacs              +--> |   ccls                |
 |     Vim/Neovim         |    |                       |
 |     Visual Studio Code |    |                       |
 |     Monaco Editor      |    |                       |
 +------------------------+    +-----------------------+
```

在2019.7.24，linux 内核的.gitignore增加了对于lsp的支持，是时候跟上潮流了。
![内核的gitignore](https://upload-images.jianshu.io/upload_images/9176874-8d57913135875846.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 丝般顺滑: async
另一个新特性是 async 。async 的效果当然就是快，当一个插件存在其 async 的版本，那么毫无疑问，就应该使用async版本。

文件树插件，我之前一直都是使用 nerdtree 的，直到有一天我用 vim 打开linux kernel，我发现光标移动都非常的困难，我开始以为是终端的性能问题，但是在 htop 中发现 vim 的 CPU 利用率很高，
直到将 nerdtree 替换为大神 shougou 的 defx[^17]。

关于 nerdtree 为什么不支持 async 可以参考这个 issue[^18]。

## 为什么使用 SpaceVim
VSCode 我也使用过一段时间，我觉得 VSCode 之所以学习曲线非常的平缓主要有两个原因，
1. 其提供标准配置给新手就可以直接使用了，但是vim没有一个较好的配置，几乎没有办法使用。
2. 官方提供了统一的插件市场，好的插件自动排序，再也不需要像vim这里，找到好的插件需要耐心和运气。 vimawesome 在一定程度上解决了这个问题，但是它把 YCM 排在[autocomplete](https://vimawesome.com/?q=autocomplete) 搜索的第一名，我非常的不认可。

目前，SpaceVim 比较好的解决了这些问题，利用社区的力量，SpaceVim 对于各种问题，挑选了对应的优质插件，基本可以实现开箱即用。当然你还是需要知道 vim 的基础知识和简要的阅读 Spacevim 的文档，不过这相对于一步步的配置和踩坑，消耗自己的时间和精力，好太多了。
Spacevim 还有一个很强的地方在于，配置是作为一个插件存在的，可以不断升级，而 LunarVim[^19] 这种配置，fork 到自己的分支，修改，想要升级就要 merge 主线上的冲突。

## 为什么使用 coc.nvim
最开始的时候，vim / neovim 都是没有内置 lsp 功能的，在 vim 下想要使用 lsp 就要靠 coc.nvim 这种插件， 类似的工具官方列举了很多[^14], 
coc.nvim 的宗旨就是*full language server protocol support as VSCode* , 到目前为止，我还是认为内置的 lsp 和 coc.nvim 的完善度还是存在一些差距。

不过，内置 lsp 和 lua 作为配置语言是 neovim 的一个新的发展趋势，我们就静观其变吧。

## [ ] 为什么应该使用 neovim 而不是 vim

## 安装
安装可以参考 install 目录下的的脚本(有待完善和测试)，下面是详细的解释。安装成功需要注意两点:
1. 代理 : 尽管 python, pacman/apt-get/yum，npm, docker 都是可以使用国内镜像，但是部分还是需要国外的，比如 Microsoft Python Language Server 。 实现代理的方法在 github 上有很多教程，也可以参考我的 blog[^20]
2. 软件版本 : 在 Ubuntu 16.04 上安装简直是一个噩梦，很多软件需要手动编译，不过在 Ubuntu 20.04 上问题不大，下面以 20.04 作为例子，其他的 distribution 例如 Arch Linux, Manjaro 应该类似。

本配置的架构如下图所示。
```
+-----------------+
|                 |
|     my config   | 在 SpaceVim 的基础上整合 coc.nvim，同时添加一些插件和配置
|                 |
+-----------------+
|                 |
|     coc.nvim    | 提供 lsp 功能，提供类似 VSCode 的优雅体验，完美支持C/C++。
|                 | coc.nvim 同样可以添加插件，比如 coc-clang。
+-----------------+
|                 |
|     SpaceVim    | 一个模块化，功能齐全的 vim distribution。
|                 |
+-----------------+
|                 |
|     Neovim      | 编辑器，当没有任何配置的时候，比较难用。
|                 |
+-----------------+
```
整个环境的安装主要是 neovim SpaceVim coc.nvim ccls，下面说明一下安装主要步骤以及其需要注意的一些小问题。对于新手，安装过程并不简单，遇到问题多Google，或者issue直接和我讨论。

1. 推荐使用 [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)，由于neovim的更新速度更快，新特性支持更好。安装完成之后检查版本，最好大于v0.4.0.

```
➜  Vn git:(master) ✗ sudo apt install neovim
➜  Vn git:(master) ✗ nvim --version
NVIM v0.4.3
Build type: Release
LuaJIT 2.0.5
Compilation: /usr/bin/cc -march=x86-64 -mtune=generic -O2 -pipe -fno-plt -O2 -DNDEBUG -DMIN_LOG_LEVEL=3 -Wall -Wextra -pedantic -Wno-unused-parameter -Wstrict-prototypes -std=gnu99 -Wshadow -Wconversion -Wmissing-prototypes -Wimplicit-fallthrough -Wvla -fstack-protector-strong -fdiagnostics-color=always -DINCLUDE_GENERATED_DECLARATIONS -D_GNU_SOURCE -DNVIM_MSGPACK_HAS_FLOAT32 -DNVIM_UNIBI_HAS_VAR_FROM -I/build/neovim/src/build/config -I/build/neovim/src/neovim-0.4.3/src -I/usr/include -I/build/neovim/src/build/src/nvim/auto -I/build/neovim/src/build/include
Compiled by builduser

Features: +acl +iconv +tui
See ":help feature-compile"

   system vimrc file: "$VIM/sysinit.vim"
  fall-back for $VIM: "/usr/share/nvim"

Run :checkhealth for more info
```

2. 第二步， 按照Spacevim 安装的[官方文档](https://spacevim.org/cn/quick-start-guide/)安装SpaceVim。
3. **保证yarn/npm使用国内镜像，部分插件需要使用yarn/npm安装，如果不切换为国内镜像，***很容易***出现安装失败。**，切换方法参考[这里](https://zhuanlan.zhihu.com/p/35856841). 安装完成之后检查:

```
➜  Vn git:(master) ✗ yarn config get registry && npm config get registry
https://registry.npm.taobao.org
https://registry.npm.taobao.org/
```

4. 安装 ccls。也可以参考其[官方文档](https://github.com/MaskRay/ccls/wiki/Build)手动编译获取最新版。

```
➜  Vn git:(master) ✗ sudo apt install ccls
➜  Vn git:(master) ✗ ccls -version
ccls version 0.20190823.6-1~ubuntu1.20.04.1
clang version 10.0.0-4ubuntu1
```

5. 复制本配置

```sh
cd ~ # 保证在根目录
rm -r .SpaceVim.d # 将原来的配置删除
git clone https://github.com/martins3/My-Linux-config .SpaceVim.d 
nvim # 打开vim 将会自动安装所有的插件
```

6. 在nvim中间执行 `checkhealth` 命令，其会提醒需要安装的各种依赖, 比如 xclip 没有安装，那么和系统的clipboard和vim的clipboard之间复制会出现问题。neovim 的 python 的没有安装可能导致直接不可用。

```
sudo apt install xclip

# archlinux 请使用 wl-clipboard 替代xclip
# sudo pacman -S wl-clipboard

sudo pip3 install neovim
sudo apt install ctags # Markdown 的导航栏需要
```

注: 感谢 [@Limaomao821](https://github.com/Martins3/My-Linux-config/issues/10) 指出，其中 Python2 和 Ruby 的依赖是不需要安装。
以及 [@Korov](https://github.com/Martins3/My-Linux-config/issues/11) 指出 archlinux 的剪切板使用 wl-clipboard


例如下面是我的配置的截图。
![checkhealth screenshot](https://upload-images.jianshu.io/upload_images/9176874-690ec7a23ba8826e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


7. 安装[bear](https://github.com/rizsotto/Bear)。ccls 需要通过 bear 生成的 compile_commands.json 来构建索引数据。

```
sudo apt install bear
```

注：使用 bear 生成 compile_commands.json 是一种通用的方法，但是不同的 build 工具和项目还存在一些捷径可走:
1. linux 内核使用自带的脚本 `scripts/clang-tools/gen_compile_commands.py`，具体可以参考[这里](https://patchwork.kernel.org/patch/10717125/)，这样的话就不用更改一次 .config 就重新编译整个内核。
2. cmake [生成 compile_commands.json 的方法](https://stackoverflow.com/questions/23960835/cmake-not-generating-compile-commands-json)
3. [ninja](https://ninja-build.org/manual.html)

```
ninja -t compdb > compile_commands.json
```

4. [ccls documentation for more](https://github.com/MaskRay/ccls/wiki/Project-Setup)

## 以 Linux 内核为例

```
git clone https://mirrors.tuna.tsinghua.edu.cn/git/linux.git
cd linux
# 使用标准配置，参考 :  https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/ch11s03.html
make defconfig
# 编译内核
make -j8
# 在 xxx 之后的内核中间, 利用生成 compile_commands.json
scripts/clang-tools/gen_compile_commands.py
# 第一次打开的时候，ccls 会生成索引文件，此时风扇飞转属于正常现象，之后不会出现这种问题
nvim 
```

一个工程只要生成 compile_commands.json，那么一切就大功告成了。

## 基本操作
基本操作是所有人都需要的比如，`h` `j` `k` `l` `e` `w` `b` `g` 等等就不说了。下面说明的内容只是我的常用操作，更多详细的操作请移步到SpaceVim，coc.nvim，ccls 以及特定插件的文档。

三个最核心的 leader 键:

| `,`               | `c`      | `<Space>`                 |
|-------------------|----------|---------------------------|
| coc.nvim 相关操作 | 窗口操作 | SpaceVim 提供的大多数操作 |

这三个键位都是可以重新映射的。

#### symbol search
利用 coc.nvim 可以方便实现符号搜索:

| key binding | function                 |
|-------------|--------------------------|
| `,` `o`     | 在当前文件中间搜索该符号 |
| `,` `s`     | 整个工程中间搜索该符号   |

在 fork.c 中间搜索 clone 这个符号:
![DeepinScreenshot_select-area_20210426163057.png](https://upload-images.jianshu.io/upload_images/9176874-6c63b4c599ecd69e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在整个 Linux 工程中间搜索 sysclone 这个符号:
![DeepinScreenshot_select-area_20210426163022.png](https://upload-images.jianshu.io/upload_images/9176874-e9ca004de864b7bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### string search
[vim-searchindex](https://github.com/google/vim-searchindex) 可以显示当前是第几个文本项:
![显示拼配项](https://raw.githubusercontent.com/google/vim-searchindex/master/vim-searchindex.gif)

spacevim 配置提供了强大的[异步搜索功能](https://spacevim.org/grep-on-the-fly-in-spacevim/), 比较常用的是:

| key binding     | function                                  |
|-----------------|-------------------------------------------|
| `Space` `s` `/` | 实时动态搜索(grep on the fly)             |
| `Space` `s` `p` | 在整个工程中搜索该字符串                              |
| `Space` `s` `b` | 在所有打开 buffer 中搜索该字符串                    |
| `Space` `s` `P` | 在整个工程中搜索**对于光标所在**字符串          |
| `Space` `s` `b` | 在所有打开的 buffer 中搜索**对于光标所在** 字符串 |


#### file tree
参考SpaceVim的[文档](https://spacevim.org/documentation/#file-tree)，我这里总结几个我常用的:

| key binding     | function                                          |
|-----------------|---------------------------------------------------|
| `Space` `f` `o` | 将当前的文件显示在filetree中间              |
| `r`             | 相当于shell中间的mv命令，实现文件的重命名或者移动 |
| `d`             | 删除                                              |
| `j`             | 向下移动                                          |
| `k`             | 向上移动                                          |

更多详细使用，可以直接阅读SpaceVim的源代码，位置在 : `~/.SpaceVim/config/plugins/defx.vim`

#### window
因为 window leader 键位被我重新映射为 `c`，如果 window leader 是被映射其他键位，比如 `x`, 那么水平拆分为 `x` `g`
```vim
    " 重新映射 window leader 键位
    let g:spacevim_windows_leader = 'c'
```


| key binding       | function       |
|-------------------|----------------|
| `<Tab>`           | 进入下一个窗口 |
| `c` `g`           | 水平拆分窗口   |
| `q`               | 关闭窗口       |
| `<Space>` `w` `m` | 当前窗口最大化 |


#### buffer

| key binding       | function                                                                  |
|-------------------|---------------------------------------------------------------------------|
| `,` `b`           | 搜索 buffer，前面提到过的，这个主要用于打开的 buffer 的数量非常多的情况下 |
| `,` num           | 切换当前窗口到第 num 个 buffer                                            |
| `<Space>` `b` `c` | 关闭其他已经保存的 buffer                                                 |

#### navigate
1. 利用[LeaderF](https://github.com/Yggdroot/LeaderF) 快速搜索file，buffer，function 等。搜索文件使用 `,` `s` + 文件名, 同样的，搜索 buffer 的方法类似 : `,` `b` + buffer 名称。
![搜索文件](https://upload-images.jianshu.io/upload_images/9176874-2c447589c614dbed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. 利用 [vista](https://github.com/liuchengxu/vista.vim) 实现函数侧边栏导航(类似于tagbar) ，打开关闭的快捷键 `<F2>`。

![导航栏](https://upload-images.jianshu.io/upload_images/9176874-59005a8b32a8b22e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### define reference
这些功能都是lsp提供的，详细的配置在 plugin/coc.vim 中间，此处列举常用的。

1. `g` `d` : 跳转到定义
2. `g` `r` : 当只有一个 ref 的时候，直接跳转，当存在多个的时候，显示如下窗口，可以逐个选择:
![查找引用](https://upload-images.jianshu.io/upload_images/9176874-47415692f924d0c8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### comment
在需要查询的函数或者变量上 : `K`，注释将会显示在悬浮窗口上。

![查找注释](https://upload-images.jianshu.io/upload_images/9176874-7d4916f3766ee4b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### documentation
在需要查询的函数上 : `Ctrl` `]`，相关文档将会显示在窗口上方。使用本功能需要安装[cppman](https://github.com/aitjcize/cppman) 以及缓存文档。
```
pip install cppman
cppman -c
```

![查找`get_id`文档](https://upload-images.jianshu.io/upload_images/9176874-640596fe5a653d60.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

和`查找注释`的功能区别在于，`K`是找到该函数的定义，然后显示函数或者变量"附近"(函数上方或者变量右侧的注释)，而查找文档是从 http://cplusplus.com/ 和 http://cppreference.com/ 中间获取文档。

#### snippet
基于[UltiSnips](https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt) 可以自己向 UltiSnips/c.snippets，UltiSnips/cpp.snippets 中间添加 C/C++ 的自己定义代码段。 以前刷OJ的时候每次都不知道要加入什么头文件，然后就写了一个自定义 snippet，一键加入所有常用的头文件。

```snippets
snippet import
#include <iostream>
// 省略部分头文件，具体内容在下方的截图中间
#include <unordered_map>

using namespace std;

int main(){
	${0}
	return 0;
}
endsnippet
```

这样，然后每次只需要输入 import 这些内容就自动出现了，效果如下。
![此时只需要按下Enter，这些内容就会自动出现](https://upload-images.jianshu.io/upload_images/9176874-50be9343756e731f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


一般的自动补全coc.nvim 无需另外的配置，效果如下。
![自动补全](https://upload-images.jianshu.io/upload_images/9176874-daac0f5b05792dba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### git
SpaceVim 的[git layer](https://spacevim.org/layers/git/) 对于 git 的支持非常好，其相关的快捷键都是 `<Space>` `g` 开头的，非常好用。

在此基础上，我添加两个小功能:
1. [lazygit](https://github.com/jesseduffield/lazygit)，利用 [floaterm](https://github.com/voldikss/vim-floaterm)，在vim 中间运行 lazygit。
2. [GitMessenger](https://github.com/voldikss/vim-floaterm)可以显示所在行的 git blame 信息。
```vim
    call SpaceVim#custom#SPC('nnoremap', ['g', 'm'], 'GitMessenger', 'show commit message in popup window', 1)
    call SpaceVim#custom#SPC('nnoremap', ['g', 'l'], 'FloatermNew lazygit', 'open lazygit in floaterm', 1)
```

#### format
`Space`  `r`  `f` 格式化当前文件，支持C/C++ , Rust 和 Python 等。

可以通过一个工程的目录下的 `.clang-format` 来实现配置 C/C++ 的格式样式:
1. https://github.com/MaskRay/ccls/blob/master/.clang-format : 将代码格式为 LLVM 风格
2. https://github.com/torvalds/linux/blob/master/.clang-format : 代码格式为 linux kernel 风格

#### rename
有时候，写了一个函数名，然后多次调用，最后发现函数名的单词写错了，一个个的修改非常的让人窒息。使用 `,` `r` `n` 在需要重命名的元素上，即可批量重命名。

#### debug
关于 vim 如何集成gdb。我个人平时使用下面两个项目辅助 gdb 的使用:
1. https://github.com/cyrus-and/gdb-dashboard
2. https://www.gdbgui.com/

更多的参考 : https://scattered-thoughts.net/writing/the-state-of-linux-debuggers/

#### terminal
利用 `voidkiss/folaterm` 可以实现将终端以float window的形式打开，映射的快捷键分别为:
- `Ctrl` `n` : 创建新的 terminal window
- `Ctrl` `p` : 切换到 `prev` 的 terminal window
- `Fn5` : 显示/隐藏窗口

下面是在打开悬浮终端，并且运行 htop 的结果:
![floaterm](https://upload-images.jianshu.io/upload_images/9176874-32e6bbbc08cb4b8c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
## 扩展
需要说明的是，本配置并不局限于C/C++，只是相对其他语言，我比较熟悉C/C++，所以以此为例。由于 SpaceVim 的 layer 和 coc.nvim 的 extension，将上述内容可以非常容易迁移到其他类型的工作上。

#### 基于SpaceVim的扩展 以Latex为例子
- 如何扩展

在 init.toml 中间添加
```toml
[[layers]]
  name = "lang#latex"
```

- 效果

`Space` `l` `l` 启动编译， 保存的时候，自动更新，并且更新输出到 zathura 中间。
![使用 zathura 预览](https://upload-images.jianshu.io/upload_images/9176874-b51f76620f214709.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 原理

SpaceVim 的强大之处是将众多插件融合在一起，当在使用 latex layer，那么 spacevim 会自动让包管理器安装 [vimtex](https://github.com/lervag/vimtex)，并且重新映射快捷键。
看一下其[文档](https://spacevim.org/layers/lang/latex/)和[源码](https://github.com/SpaceVim/SpaceVim/blob/master/autoload/SpaceVim/layers/lang/latex.vim)就非常清楚了。

- 说明

如果想要书写中文，需要修改默认的 latex engine，在 ~/.latexmkrc 中设置:
```
$pdf_mode = 5; 
```
参考:
- https://tex.stackexchange.com/questions/429274/chinese-on-mactex2018-simple-example
- https://tex.stackexchange.com/questions/501492/how-do-i-set-xelatex-as-my-default-engine

#### 基于coc.nvim的扩展 以Python为例
- 如何扩展

添加 coc-python 这个插件，并且启用微软的 python language server，也就是 disable 掉 jedi, 这一步是**必须的**，jedi 我从来没有正常成功使用过，总是崩溃。
```vim
let s:coc_extensions = [
			\ 'coc-python',

call coc#config("python.jediEnabled", v:false)
```

- 效果

![查找引用](https://upload-images.jianshu.io/upload_images/9176874-f759cf59365d5c57.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![查找](https://upload-images.jianshu.io/upload_images/9176874-773f3dabb59d0b97.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 原理

s:coc_extensions 添加 coc-python 之后，会自动安装[coc-python](https://github.com/neoclide/coc-python)和[language server](https://github.com/microsoft/python-language-server)。
通过coc.nvim，nvim 可以将自己伪装成为 vscode，coc-python 本身也是 vscode 的插件。如此，vscode 的处理 python 的技术被吸收到 vim 中间来，但是 vim 更加简洁，高效。

## 本配置源代码解释
总体来说，本配置的代码就是从上面介绍的各个项目提供的标准配置的组合，然后添加我的一些微调。

本配置的主要组成:
1. init.toml : 最基本的配置，在此处可以自己添加新的插件
2. autoload/myspacevim.vim : 一些插件的配置，一些快捷键
3. plugin/coc.vim : coc.nvim 和 ccls 的配置，几乎是[coc.nvim 标准配置](https://github.com/neoclide/coc.nvim#example-vim-configuration) 和 [ccls 提供给coc.nvim 的标准配置](https://github.com/MaskRay/ccls/wiki/coc.nvim) 的复制粘贴。
4. plugin/defx.vim : 添加了一条让 defx 忽略各种二进制以及其他日常工作中间不关心的文件。
5. UltiSnips/ : 大多数是从 https://github.com/honza/vim-snippets 中间粘贴过来的。

SpaceVim 的文档很多时候是不详细的，直接阅读代码往往是更加好的方法，比如如果想知道 defx 的使用方法，进入到 ~/.SpaceVim/ 中间，找到 defx.vim 直接阅读代码即可。

一些快捷键的说明:
1. `<F4>` 我自己写的一键运行文件，支持语言的单文件执行如 C/C++, Java, Rust等，我个人用于刷题的时候使用。
2. `<Space>`  `l`  `p` 预览markdown

## FAQ
- 为什么不使用 IDE，比如 CLion ?
    - 

## vim 的小技巧
1. 翻滚屏幕
```
# 保持屏幕内容不动，在当前屏幕中间移动
H
M
L

# 保持所在行不动，移动屏幕
zz
zt
zb

# 移动屏幕内容
Ctrl + f - 向前滚动一屏，但是光标在顶部
Ctrl + d - 向前滚动一屏，光标在屏幕的位置保持不变
Ctrl + b - 向后滚动一屏，但是光标在底部
Ctrl + u - 向后滚动半屏，光标在屏幕的位置保持不变
```
2. vim 下的 Man 命令打开的 manual 是带高亮和符号跳转的，比在终端中间直接使用 man 好多了
3. 在最后一行添加相同的字符 `Ctrl + v` `$` `A` `string appended`，[参考](https://stackoverflow.com/questions/594448/how-can-i-add-a-string-to-the-end-of-each-line-in-vim)。
4. 在 Esc 是 vim 中间使用频率非常高的键位，为了不让自己的左手小拇指被拉长，可以将 CapsLock 键映射为 Esc 键，一种修改方法为在 ~/.profile 中加入。这个方法存在一个小问题，就是需要打开一个终端窗口才可以加载这个，应为 .profile 在 login 的时候才会被执行一次。
```
setxkbmap -option caps:swapescape
```

## 其他的一些资源
- [C/C++ 项目利用 include-what-you-use 来引入头文件](https://github.com/include-what-you-use/include-what-you-use)

#### 学习
1. [Vim China](https://github.com/vim-china)
2. [vim galore](https://github.com/mhinz/vim-galore)
3. [devhints](https://devhints.io/vimscript) : 另一个 vim checksheet

#### 主题
1. [dracula](https://draculatheme.com/vim/) 目前感觉最好看的主题之一
2. [vimcolors](http://vimcolors.com/) vim 主题网站
3. [solarized](https://github.com/vim-scripts/Solarized)

#### 框架
1. [exvim](https://exvim.github.io/)
2. [spf13-vim](https://github.com/spf13/spf13-vim)
3. [The Ultimate vimrc](https://github.com/amix/vimrc)
4. [NVCode](https://github.com/ChristianChiarulli/nvim) 基于 coc.nvim 的一个配置

#### 衍生
1. [vim cube](https://github.com/oakes/vim_cubed) : 让 vim 在三维中显示
2. [vim.wasm](https://github.com/rhysd/vim.wasm) : 在 vim 在网页中间使用
3. [neovide](https://github.com/Kethku/neovide) : 一个酷炫的 GUI 客户端

## ref
[^1]: [cscope](http://cscope.sourceforge.net/)
[^2]: [SpaceVim](http://spacevim.org/)
[^3]: [coc.nim](https://github.com/neoclide/coc.nvim)
[^4]: [Vim 8 中 C/C++ 符号索引：GTags 篇](https://zhuanlan.zhihu.com/p/36279445)
[^5]: [Language Server Protocal](https://microsoft.github.io/language-server-protocol/)
[^6]: [github: how to exit vim](https://github.com/hakluke/how-to-exit-vim)
[^7]: https://stackoverflow.blog/2017/05/23/stack-overflow-helping-one-million-developers-exit-vim/
[^8]: https://vi.stackexchange.com/questions/177/what-is-the-purpose-of-swap-files
[^9]: https://github.com/yangyangwithgnu/use_vim_as_ide
[^10]: [YCM](https://github.com/ycm-core/YouCompleteMe)
[^11]: [ctags](https://github.com/universal-ctags/ctags)
[^12]: [ccls](https://github.com/MaskRay/ccls)
[^13]: [lsp servers](https://microsoft.github.io/language-server-protocol/implementors/servers/)
[^14]: [lsp tools](https://microsoft.github.io/language-server-protocol/implementors/tools/)。
[^15]: https://github.com/rust-analyzer/rust-analyzer
[^16]: [nerdtree](https://github.com/preservim/nerdtree)
[^17]: [defx](https://github.com/Shougo/defx.nvim)
[^18]: https://github.com/preservim/nerdtree/issues/1170
[^19]: https://github.com/ChristianChiarulli/LunarVim
[^20]: [corss the GFW](https://martins3.github.io/gfw.html)

**转发 CSDN 按侵权追究法律责任，其它情况随意。**
