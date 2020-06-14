# 2020年vim的C/C++配置

<details open="">
  <summary>目录</summary>
<!-- vim-markdown-toc GitLab -->

- [前言](#前言)
- [效果](#效果)
- [如何入门](#如何入门)
- [欢迎来到 Language Server Protocal 和 async 的时代](#欢迎来到-language-server-protocal-和-async-的时代)
- [安装过程以及注意要点](#安装过程以及注意要点)
- [实战](#实战)
- [基本操作](#基本操作)
    - [file tree](#file-tree)
    - [window](#window)
    - [buffer](#buffer)
    - [搜索和导航](#搜索和导航)
    - [符号跳转和引用查找](#符号跳转和引用查找)
    - [comment](#comment)
    - [documentation](#documentation)
    - [snippet](#snippet)
    - [git](#git)
    - [format](#format)
    - [rename](#rename)
    - [debug](#debug)
    - [代码时间统计](#代码时间统计)
- [扩展](#扩展)
    - [基于SpaceVim的扩展 以Latex为例子](#基于spacevim的扩展-以latex为例子)
    - [基于coc.nvim的扩展 以Python为例](#基于cocnvim的扩展-以python为例)
- [本配置源代码解释](#本配置源代码解释)
- [vim 的小技巧](#vim-的小技巧)
- [其他的一些资源](#其他的一些资源)
    - [vim学习](#vim学习)
    - [主题](#主题)
    - [框架](#框架)
- [参考](#参考)

<!-- vim-markdown-toc -->
</details>

## 前言
有问题欢迎[issue](https://github.com/Martins3/My-Linux-config/issues?q=is%3Aissue)。

**至少在我放弃使用tagbar，ctags，nerdtree，YouCompleteMe的时候**，这些工具各有各的或大或小的问题。

我平时主要C/C++，处理的工程小的有 : 刷Leetcode(几十行)，中型的有 : ucore 试验(上万行)，linux kernel(千万行)，用目前的配置都是丝般顺滑。当然，得益于coc.nvim的强大，本配置也可以较好的处理Python，Java，Rust等语言。

本文面向vim初学者，让大家快速上手并且将vim投入到自己实际使用上，所以使用[SpaceVim](http://spacevim.org/) + [coc.nim](https://github.com/neoclide/coc.nvim)作为基础，至于如何一步步从零的搭建自己的vim配置，对于新手很难，当然我也不会。SpaceVim的默认提供各种基础设施的解决方案，比如status line，搜索，markdown预览高亮，其也虽然提供了 [C/C++ 的配置](https://spacevim.org/layers/lang/c/)，但是我个人觉得并不好用，而coc.nvim吸收了VSCode的优点，两者融合之后，体验丝般顺滑。

以下部分内容有凭借印象写下的，如有不对，欢迎指正。如果觉得哪里不清楚的，欢迎讨论。
## 效果
![总体效果](https://upload-images.jianshu.io/upload_images/9176874-e3b90299db81d2bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 如何入门
其实关于vim的基本知识教程有很多，这里我推荐两个网站
1. [openvim](https://www.openvim.com/) : 交互式的学习vim
2. [Vim Cheat Sheet](https://vim.rtorr.com/lang/zh_cn) : vim 通用快捷键清单

如果完全没有基础，建议使用第一个打牢基础之后，然后就直接将vim用于实战中间，因为这些快捷键都是肌肉记忆，无非多熟悉一下而已。 第二个是强化补充的，建议一次学习三两个，不要指望一次全部背下来，不然很痛苦。

vim 的学习曲线陡峭主要就是在最开始的hjkl这些快捷键的记忆，但是坚持最多几天，之后就学习就非常平缓了，无非是装装插件，重新映射一下快捷键之类的事情。

虽然我使用了很长时间的vim，但是两个东西我依旧觉得非常坑，那就是退出和复制。关于vim如何退出，闹出很多笑话，比如有人创建一个[仓库](https://github.com/hakluke/how-to-exit-vim)，用于收集各种退出的方法。stackoverflow 的[报告](https://stackoverflow.blog/2017/05/23/stack-overflow-helping-one-million-developers-exit-vim/)说，其帮助了一百万人次如何退出vim。
1. 我使用 `:xa` 退出vim。 `x` 表示保存并且关闭buffer，`a`表示运用于所有的。有时候出现意外关闭vim，再次打开文件可以出现警告，解决办法是 : 首先利用.swp 文件进行恢复，然后手动清理 `~/.cache/SpaceVim/swap` .swp 文件
![冲突读写](https://upload-images.jianshu.io/upload_images/9176874-796e49d5f2c60489.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
2. `\` `y` 和 `\` `p` 实现复制粘贴。不同的配置下，复制粘贴的不同，在本配置下，复制粘贴的 leader 键是 `\`。

## 欢迎来到 [Language Server Protocal](https://microsoft.github.io/language-server-protocol/) 和 async 的时代
> 跳过本小节并不影响使用本配置，此处只是为了说明Language Server Protocal(下面简称lsp) 和 async 的好处。

在2019.7.24，linux 内核的.gitignore增加了对于lsp的支持，是时候跟上潮流了。
![内核的gitignore](https://upload-images.jianshu.io/upload_images/9176874-8d57913135875846.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

lsp 定义了一套标准编辑器和 language server 之间的规范。不同的语言需要不同的Language Server，比如C/C++ 需要 [ccls](https://github.com/MaskRay/ccls), Rust语言采用[rls](https://github.com/rust-lang/rls)，Language server 的清单在[这里](https://microsoft.github.io/language-server-protocol/implementors/servers/)。在lsp的另一端，也就是编辑器这一端，也需要对应的实现，其列表在[这里](https://microsoft.github.io/language-server-protocol/implementors/tools/)。也就是说，由于lsp的存在，一门语言的language server可以用于所有的支持lsp的编辑器上，大大的减少了重复开发。其架构图大概是下面的这个感觉，其中需要说明一下vim现在逐步将lsp内置到编辑器中间，所以Editor Plugin 的那一层估计用不了多久就会消失吧!
```
 +------------------------+    +---------------------------+    +-----------------------+
 |                        |    |                           |    |                       |
 |     Atom               |    |   coc.nvim                |    |                       |
 |     Emacs              +--> |   LanguageClient-neovim   +--> |   clangd/ccls/cquery  |
 |     Vim/Neovim         |    |   vim-lsp                 |    |                       |
 |     Visual Studio Code |    |                           |    |                       |
 |     Monaco Editor      |    |                           |    |                       |
 +------------------------+    +---------------------------+    +-----------------------+
 |                        |    |                           |    |                       |
 |      Editor            | <--+  Editor Plugin            | <--+   Language Server     |
 |                        |    |                           |    |                       |
 |                        |    |                           |    |                       |
 +------------------------+    +---------------------------+    +-----------------------+
```
lsp让静态检查变得异常简单，当不小心删除掉一个`put_swap_page`这个函数字符之后，立刻得到如下的效果:
![静态检查](https://upload-images.jianshu.io/upload_images/9176874-961f534527ce3236.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

基于lsp的高亮，函数，变量，宏，关键字都是有自己的颜色，但是基本的高亮就只有关键字显示有所不同。你可以对别上下两张图，上图是基于语义的高亮，类型 `swp_entry_t`, 宏 `xa_lock_irq`, 成员 `i_pages` 等都是使用特定的颜色，而下图中只要 `void` `struct` 显示了高亮。
![不是基于语义的高亮](https://upload-images.jianshu.io/upload_images/9176874-02a2e65b22a29ff2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当使用上了lsp之后，之前写C/C++P必备的[YCM](https://github.com/ycm-core/YouCompleteMe)(用于自动补全，静态检查等)和[ctags](https://github.com/universal-ctags/ctags)(用于符号跳转)终于可以离开了。YCM对于小的项目还是工作的不错的，但是大型项目显得笨重，毕竟 YCM 不仅支持 C 语言，支持 Java, Rust, Go 等等，而且其不会生成索引，也就是每次打开大型项目都可以听见电脑疯转一会儿。此外，YCM 的安装总是需要手动安装。ctags 似乎不是基于语义的索引，而是基于字符串匹配实现，所以会出现误判，比如两个文件中间都定义了 static 的同名函数，ctags 往往会将两者都找出来。ctags 是无法查找函数的引用的，只能查找定义。当我知道 ctags 可以同时支持几十种语言的时候，ctags 存在这些问题，我就再也不感到奇怪了。gtags 解决了 ctags 查找引用的问题，其同样支持大量的语言，但是跳转精度，索引自动生成等根本问题没有被解决。与之相对的是，一个lsp一般只支持其对应的一门语言。

到此，曾经为了在vim中间书写C/C++，你需要安装 ctags 生成索引，需要安装 ctags 的 vim 插件在 vim 中间使用 ctags，自动更新索引数据库的插件，YCM实现静态检查，最最让人崩溃的是，那一天你忽然想使用vim写一个新的语言，比如 Java，类似的操作你又需要重新走一遍，而且还要手动映射快捷键，来保证这些快捷键不会互相冲突。

利用 coc.nvim 可以获取极佳的 lsp 体验 ，因为 lsp 是微软开发 vscode 提出的，coc.nvim 的宗旨就是*full language server protocol support as VSCode*。

另一个新特性是async(异步机制)。async 的特定就是快，当一个插件存在其async的版本，那么毫无疑问，使用async版本。[nerdtree](https://github.com/preservim/nerdtree) 使用vim的人应该是无人不知，无人不晓吧，我之前一直都是使用这一个插件的，直到有一天我用vim打开linux kernel，并且打开nerdtree之后，光标移动都非常的困难，我开始以为是终端的性能问题，后来以为是lsp的问题，直到将nerdtree替换为[大神shougou的defx](https://github.com/Shougo/defx.nvim)。我想，如果没有 SpaceVim，我永远都不要找到 defx 这一个插件。

VSCode 我也使用过一段时间，我觉得VSCode 之所以学习曲线非常的平缓主要有两个原因，一是其提供标准配置给新手就可以直接使用了，但是vim没有一个较好的配置，几乎没有办法使用。二是，官方提供了统一的插件市场，好的插件自动排序，再也不需要像vim这里，找到好的插件需要耐心和运气。 vimawesome 在一定程度上解决了这个问题，但是它把 YCM 排在[autocomplete](https://vimawesome.com/?q=autocomplete) 搜索的第一名，我非常的不认可。目前，SpaceVim 比较好的解决了这个问题，利用社区的力量，SpaceVim 对于各种问题，挑选了对应的优质插件，基本可以实现开箱即用(当然你需要知道vim的基础知识和简要的阅读Spacevim的文档，不过这相对于一步步的配置和踩坑，消耗自己的时间和精力，好太多了)。

想知道插件是否过时，github 上会显示最后更新时间，如果一个项目好几年都没有更新过，比如 [use_vim_as_ide](https://github.com/yangyangwithgnu/use_vim_as_ide)，那么基本没有阅读的价值了，因为vim社区日新月异，不进则退。
## 安装过程以及注意要点
本配置的架构如下图所示。
```
+-----------------+
|                 |
|     my config   | 在 SpaceVim 的基础上整合coc.nvim，同时添加一些插件和配置
|                 |
|                 |
+-----------------+
|                 |
|     Coc.nvim    | 提供lsp功能，完美吸收VSCode的优雅体验，完美支持C/C++。coc.nvim 同样可以添加插件 
|                 | 
+-----------------+
|                 |
|     SpaceVim    | 一个模块化，功能齐全的vim distribution，虽然其中对于C/C++的支持个人不认同，但是颜色主题等基础设施非常完善。
|                 |
+-----------------+
|                 |
|     Neovim      | 编辑器，当没有任何配置的时候，非常难用。
|                 |
+-----------------+
```
整个环境的安装主要是 neovim SpaceVim coc.nvim ccls，下面说明一下安装主要步骤以及其需要注意的一些小问题。对于新手，安装过程并不简单，遇到问题多Google，或者issue直接和我讨论。

1. 推荐使用 [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)，由于neovim的更新速度更快，新特性支持更好。安装完成之后检查版本，最好大于v0.4.0.
```
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
4. 安装ccls，其[官方文档](https://github.com/MaskRay/ccls/wiki/Build)，检查其版本。ccls 记得及时更新，如果ccls工作不正常，更新一般可以解决。
```
➜  Vn git:(master) ✗ ccls -version
ccls version 0.20190823.5-17-g41e7d6a7
clang version 9.0.1 
```
5. 复制本配置
```sh
cd ~ # 进入到根目录
rm -r .SpaceVim.d # 将 SpaceVim 删除
# git clone --depth=1 https://github.com/Martins3/My-Linux-config .SpaceVim.d # 将本项目的内容复制到 SpaceVim.d，--depth=1 是减少下载量
git clone https://gitee.com/martins3/My-Linux-config .SpaceVim.d # 使用 gitee，速度非常快，推荐使用
nvim # 打开vim 将会自动安装所有的插件
```
6. 在nvim中间执行 `chechealth` 命令，保证其中没有 Err 存在，一般都是各种依赖没有安装，比如 xclip 没有安装，那么和系统的clipboard和vim的clipboard之间复制会出现问题。

7. 安装[bear](https://github.com/rizsotto/Bear)，ccls 需要利用bear生成compile_commands.json。

## 实战

下面使用Linux Kernel 作为例子。
```
git clone https://mirrors.tuna.tsinghua.edu.cn/git/linux.git
cd linux
make defconfig  # 使用标准配置，参考 :  https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/ch11s03.html
bear make -j8  # 生成compile_commands.json
nvim # 第一次打开的时候，ccls 会生成索引文件，此时机器飞转属于正常现象，之后不会出现这种问题
```
一个工程只要可以正常编译，生成了compile_commands.json，那么一切就大功告成了。如果其中的nvim工作不正常，瞎报错，无法跳转，一般是安装有问题，如果解决不了，你可以issue。

## 基本操作
基本操作是所有人都需要的比如，h j k l e w b g 等等就不说了。下面说明的内容只是我的常用操作，更多详细的操作请移步到SpaceVim，coc.nvim，ccls 以及特定插件的文档。

注意: vim 默认的 leader 键，加上前面提到的两个特殊功能leader, 一共存在三个 leader 键，其功能总结如下:
| `,`                         | `\`      | `c`      |
| 通用leader 键，包含各种作用 | 辅助粘贴 | 窗口操作 |
这三个键位都是可以重新映射的。


#### file tree
参考SpaceVim的[文档](https://spacevim.org/documentation/#file-tree)，我这里总结几个我常用的
| key binding     | function                                          |
|-----------------|---------------------------------------------------|
| `Space` `f` `o` | 将当前的文件显示在filetree中间              |
| `r`             | 相当于shell中间的mv命令，实现文件的重命名或者移动 |
| `d`             | 删除                                              |
| `j`             | 向下移动                                          |
| `k`             | 向上移动                                          |

更多详细使用，可以直接阅读SpaceVim的源代码，位置在 : `~/.SpaceVim/config/plugins/defx.vim`

#### window
1. `<Tab>` : 进入下一个窗口
2. `c` `g` : 水平拆分窗口。因为 window leader 键位被我重新映射为 `c`，如果是被映射其他键位，比如 `x`, 那么水平拆分为 `x` `g`
```vim
    " 重新映射 window leader 键位
    let g:spacevim_windows_leader = 'c'
```
3. `q` : 关闭窗口
4. `<Space>` `w` `m` 当前窗口最大化

#### buffer
1. `,` `b` : 搜索 buffer，前面提到过的，这个主要用于打开的 buffer 的数量非常多的情况下。
2. `,` + num : 切换当前窗口到第 num 个 buffer
3. `<Space>` `b` `c` 关闭其他已经保存的 buffer 

#### 搜索和导航
1. 利用[LeaderF](https://github.com/Yggdroot/LeaderF) 快速搜索file，buffer，function 等。在我的配置中间 leader 键是 `,` ，所以搜索文件使用 `,` `f` + 文件名的 subsequence
搜索 buffer 的方法类似 : `,` `b` + 想要搜索的 buffer 名称的 subsequence。
![搜索文件](https://upload-images.jianshu.io/upload_images/9176874-2c447589c614dbed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. 利用 [vista](https://github.com/liuchengxu/vista.vim) 实现函数侧边栏导航(类似于tagbar) ，打开关闭的快捷键 `<F2>`。

![导航栏](https://upload-images.jianshu.io/upload_images/9176874-59005a8b32a8b22e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


3. vista 和 LeaderF 都提供了函数搜索功能，被我映射为: `Space` `s` `f` 和 `Space` `s` `F` 
```vim
    call SpaceVim#custom#SPC('nnoremap', ['s', 'f'], 'Vista finder', 'search ctags simbols with Vista ', 1)
    call SpaceVim#custom#SPC('nnoremap', ['s', 'F'], 'LeaderfFunction!', 'search ctags simbols with Vista', 1)
```
其实它们的功能不限于搜索函数，比如搜索 markdown 的标题
![搜索markdown标题](https://upload-images.jianshu.io/upload_images/9176874-44f63af5e63d30d9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 符号跳转和引用查找
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
`Space`  `r`  `f` 格式化当前文件，仅仅支持C++/C 和 Rust。

#### rename
有时候，写了一个函数名，然后多次调用，最后发现函数名的单词写错了，一个个的修改非常的让人窒息。使用 `,` `r` `n` 在需要重命名的元素上，即可批量重命名。

#### debug
关于vim如何集成gdb，现在存在非常多的插件，我没有仔细研究。我个人平时使用下面两个项目辅助 gdb 的使用:
1. https://github.com/cyrus-and/gdb-dashboard
2. https://www.gdbgui.com/

#### 代码时间统计
利用商业软件[wakatime](https://wakatime.com/)，无需特殊的配置，如果不需要在 init.toml 中间将如下代码注释掉即可:
```toml
[[custom_plugins]]
    name = 'wakatime/vim-wakatime'
```
效果如下:
![wakatime](https://upload-images.jianshu.io/upload_images/9176874-7989124874e02ac6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

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

添加 coc-python 这个插件，并且启用微软的 python language server
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

## [本配置](https://github.com/Martins3/My-Linux-config)源代码解释
SpaceVim 的文档往往是过时的或者是不详细的，直接阅读代码往往是更加好的方法，比如如果想知道 defx 的使用方法，进入到 ~/.SpaceVim/ 中间，找到 defx.vim 直接阅读代码即可。

本配置的主要组成:
0. init.toml : 最基本的配置，以及自定义的插件
1. autoload/myspacevim.vim : 一些插件的配置，一些快捷键
2. plugin/coc.vim : coc.nvim 和 ccls 的配置，几乎是[coc.nvim 标准配置](https://github.com/neoclide/coc.nvim#example-vim-configuration) 和 [ccls 提供给coc.nvim 的标准配置](https://github.com/MaskRay/ccls/wiki/coc.nvim) 的复制粘贴。
3. plugin/defx.vim : 添加了一条让 defx 忽略各种二进制以及其他日常工作中间不关心的文件。

一些快捷键的说明
1. `<F4>` 我自己写的一键运行文件，支持语言的单文件支持如 C/C++, Java, Rust等。
2. `<Space>`  `l`  `p` 预览markdown
3. `<F5>` 在悬浮窗口打开终端

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
4. 在 Esc 是 vim 中间使用频率非常高的键位，为了不让自己的左手小拇指被拉长，可以将 CapsLock 键映射为 Esc 键，一种修改方法为在 ~/.profile 中加入。这个方法存在一个小问题，就是需要打开一个终端窗口才可以加载这个
```
setxkbmap -option caps:swapescape
```

## 其他的一些资源

#### vim学习
1. [Vim China](https://github.com/vim-china)
2. [vim galore](https://github.com/mhinz/vim-galore)

#### 主题
1. [dracula](https://draculatheme.com/vim/) 目前感觉最好看的主题之一
2. [vimcolors](http://vimcolors.com/) vim主题网站
3. [solarized](https://github.com/vim-scripts/Solarized) solarized

#### 框架
1. [exvim](https://exvim.github.io/)
5. [spf13-vim](https://github.com/spf13/spf13-vim)
6. [The Ultimate vimrc](https://github.com/amix/vimrc)

## 参考
1. https://github.com/habemus-papadum/kernel-grok
2. https://stackpointer.io/unix/linux-get-kernel-config/545/

转发 CSDN 按侵权追究法律责任，其它情况随意。
