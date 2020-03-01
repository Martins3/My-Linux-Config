# 2020年vim的C/C++配置

## 前言
**至少在我放弃使用tagbar，ctags，nerdtree，YouCompleteMe的时候**，这些工具各有各的或大或小的问题。

我平时主要C/C++，处理的工程小的有 : 刷Leetcode(几十行)，中型的有 : ucore 试验(上万行)，linux kernel(千万行)，用目前的配置都是丝般顺滑。当然，得益于coc.nvim的强大，本配置也可以较好的处理Python，Java，Rust等语言。

本文面向vim初学者，让大家快速上手并且将vim投入到自己实际使用上，所以使用[SpaceVim](http://spacevim.org/) + [coc.nim](https://github.com/neoclide/coc.nvim)作为基础，至于如何一步步从零的搭建自己的vim配置，对于新手很难，当然我也不会。

其实SpaceVim官方提供了 [C/C++ 的配置](https://spacevim.org/layers/lang/c/)，但是我用起来不是很舒服，做的修改都在[这个repo](https://github.com/Martins3/My-Linux-config) 中间

以下部分内容有凭借印象写下的，如有不对，欢迎指正。如果觉得哪里不清楚的，欢迎讨论。
## 效果
![总体效果](https://upload-images.jianshu.io/upload_images/9176874-e3b90299db81d2bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 如何入门
其实关于vim的基本知识教程有很多，这里我推荐两个网站
1. [openvim](https://www.openvim.com/) : 交互式的学习vim
2. [Vim Cheat Sheet](https://vim.rtorr.com/lang/zh_cn) : vim 通用快捷键清单

如果完全没有基础，建议使用第一个打牢基础之后，然后就直接将vim用于实战中间，因为这些快捷键都是肌肉记忆，无非多熟悉一下而已。 第二个是强化补充的，建议一次学习三两个，不要指望一次全部背下来，很痛苦。

vim 的学习曲线陡峭的我个人感觉主要就是在这一个地方，但是坚持最多一个星期，之后就学习就非常平缓了。

虽然我使用了很长时间的vim，但是两个东西我依旧觉得非常坑，那就是退出和复制:
1. 使用 `:xa` 退出vim。 `x` 表示保存并且关闭buffer，`a`表示运用于所有的。有时候出现意外关闭vim，再次打开文件可以出现冲突读写警告，可以手动清理 `~/.cache/SpaceVim/swap` .swp 文件
![冲突读写](https://upload-images.jianshu.io/upload_images/9176874-796e49d5f2c60489.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
2. `\``y` 和 `\``p` 实现复制粘贴。不同的配置下，复制粘贴的不同，在本配置下，复制粘贴的 leader 键是 `\`。

## 欢迎来到 [Language Server Protocal](https://microsoft.github.io/language-server-protocol/) 和 async 的时代
> 跳过本小节并不影响使用被配置，此处只是为了说明Language Server Protocal(下面简称lsp) 和 async 的好处。

VSCode 我也使用过一段时间，我觉得VSCode 之所以学习曲线非常的平缓主要有两个原因，一是其提供标准配置给新手就可以直接使用了，但是vim没有一个较好的配置，几乎没有办法使用。二是，官方提供了统一的插件市场，好的插件自动排序，再也不需要像vim这里，找到好的插件需要耐心和运气。
vimawesome 在一定程度上解决了这个问题，但是它把YCM排在[autocomplete](https://vimawesome.com/?q=autocomplete) 搜索的第一名，我非常的不认可。

lsp 定义了一套标准编辑器和 language server 之间的规范。不同的语言需要不同的Language Server，比如C/C++ 需要 [ccls](https://github.com/MaskRay/ccls), Rust语言采用[rls](https://github.com/rust-lang/rls)，Language server 的清单在[这里](https://microsoft.github.io/language-server-protocol/implementors/servers/)。在lsp的另一端，也就是编辑器这一端，也需要对应的实现，其列表在[这里](https://microsoft.github.io/language-server-protocol/implementors/tools/)。也就是说，由于lsp的存在，一门语言的language server可以用于所有的支持lsp的编辑器上，大大的减少了重复开发。其架构图大概是下面的这个感觉:
```
+------------------------+
|    coc.nvim,vim-lsp等  |
+------------------------+
     +-------------+
     |   lsp       |
     +-------------+
+------------------------+
|    ccls,rls等          |
+------------------------+
```
lsp让静态检查变得异常简单，当不小心删除掉一个put_swap_page这个函数字符之后，立刻得到如下的效果:
![静态检查](https://upload-images.jianshu.io/upload_images/9176874-961f534527ce3236.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
基于lsp的高亮，函数，变量，宏，关键字都是有自己的颜色，但是基本的高亮就只有关键字显示有所不同。
![不是基于语义的高亮](https://upload-images.jianshu.io/upload_images/9176874-02a2e65b22a29ff2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


当使用上了lsp之后，之前写C/C++P必备的[YCM](https://github.com/ycm-core/YouCompleteMe)(用于自动补全，静态检查等)和[ctags](https://github.com/universal-ctags/ctags)(用于符号跳转)终于可以离开了。YCM对于小的项目还是工作的不错的，但是大型项目显得笨重，毕竟YCM不仅支持C语言，支持Java, Rust, Go 等等，而且其不会实现生成索引，也就是每次打开大型项目都可以听见电脑疯转一会儿。此外，YCM 的安装总是需要手动安装。ctags 似乎不是基于语义的索引，而是基于字符串匹配实现，所以会出现误判，比如两个文件中间都定义了static的同名函数，ctags 往往会将两者都找出来。ctags 是无法查找函数的引用的，只能查找定义。

另一个新特性是async(异步机制)。async的特定就是快，当一个插件存在其async的版本，那么毫无疑问，使用async版本。[nerdtree](https://github.com/preservim/nerdtree) 使用vim的人应该是无人不知，无人不晓吧，我之前一直都是使用这一个插件的，直到有一天我用vim打开linux kernel，并且打开nerdtree之后，光标移动都非常的困难，我开始以为是终端的性能问题，后来以为是lsp的问题，直到将nerdtree替换为[大神shougou的defx](https://github.com/Shougo/defx.nvim).

很多插件是否过时，github 上会显示最后更新时间，如果一个项目好几年都没有更新过，比如 [use_vim_as_ide](https://github.com/yangyangwithgnu/use_vim_as_ide)，那么基本没有阅读的价值了，因为vim社区日新月异，不进则退。

## 安装过程以及注意要点
整个环境的安装主要是 neovim SpaceVim coc.nvim ccls

1. 推荐使用 [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)，由于neovim的更新速度更快，新特性支持更好。安装完成之后检查，最好版本大于v0.4.0.
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
2. Spacevim 安装的[官方文档](https://spacevim.org/cn/quick-start-guide/)。
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
# 因为本仓库还包含配置，使用如下命令删除
git clone --depth=1 https://github.com/Martins3/My-Linux-config .SpaceVim.d # 将本项目的内容复制到 SpaceVim.d
nvim # 打开vim 将会自动安装所有的插件
```
6. 在vim中间执行 `chechealth` 命令，保证其中没有 Err 存在，一般都是各种依赖没有安装，比如 xclip 没有安装，那么和系统的clipboard和vim的clipboard之间复制会出现问题。

7. 安装[bear](https://github.com/rizsotto/Bear)，ccls 需要利用bear生成compile_commands.json。

## 实战

下面使用Linux Kernel 作为例子。
```
git clone https://mirrors.tuna.tsinghua.edu.cn/git/linux.git
cd linux
# zcat /proc/config.gz > .config # 首先获取当且机器内核的配置，只有当前机器上的版本和源代码的版本一致的时候才有效, 所以应该使用下面的方法配置
make defconfig  # 使用标准配置，参考 :  https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/ch11s03.html
bear make -j8  # 生成compile_commands.json
nvim # 第一次打开的时候，ccls 会生成索引文件，此时机器飞转属于正常现象，之后不会出现这种问题
```

## C/C++ 用户的基本操作的详解
- 基本操作是所有人都需要的比如，h j k l e w b g 等等就不说了。


下面说明一下我常用的操作:
#### 窗口操作
1. `<Tab>` : 进入下一个窗口
2. `c` `g` : 水平拆分窗口。因为 window 被我重新映射了，如果是其他键位，比如 `x`, 那么水平拆分为 `x` `g`
```vim
    " 重新映射 window 键位
    let g:spacevim_windows_leader = 'c'
```
3. `q` : 关闭窗口
4. `<Space>` `w` `m` 当前窗口最大化

#### buffer 操作
1. `,` `b` : 搜索 buffer，前面提到过的，这个主要用于打开的 buffer 的数量非常多的情况下。
2. `,` + num : 切换当前窗口到第 num 个 buffer
3. `<Space>` `b` `c` 关闭其他已经保存的 buffer 

#### 预览和搜索
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

1. `g``d` : 跳转到定义
2. `g``r` : 当只有一个 ref 的时候，直接跳转，当存在多个的时候，显示如下窗口，可以逐个选择:
![查找引用](https://upload-images.jianshu.io/upload_images/9176874-47415692f924d0c8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 查找注释
在需要查询的函数或者变量上 : `K`

![查找注释](https://upload-images.jianshu.io/upload_images/9176874-7d4916f3766ee4b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 添加自定义代码段
基于[UltiSnips](https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt) 可以自己向 UltiSnips/c.snippets，UltiSnips/cpp.snippets 中间添加 C/C++ 的自己定义代码段。
以前刷OJ的时候每次都不知道要加入什么头文件，然后就写了一个自定义 snippet，一键加入所有常用的头文件。

```snippets
snippet import
#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <stack>
#include <sstream>
#include <climits>
#include <deque>
#include <set>
#include <utility>
#include <queue>
#include <map>
#include <cstring>
#include <algorithm>
#include <iterator>
#include <string>
#include <cassert>
#include <unordered_set>
#include <unordered_map>

using namespace std;

int main(){
	${0}
	return 0;
}
endsnippet
```

这样，然后每次只需要输入 import 这些内容就自动出现了。

一般的自动补全coc.nvim 无需另外的配置，效果如下。
![自动补全](https://upload-images.jianshu.io/upload_images/9176874-daac0f5b05792dba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### git 支持
SpaceVim 的[git layer](https://spacevim.org/layers/git/) 对于 git 的支持非常好，没有什么需要修改的，其相关的快捷键都是 `<Space>` `g` 开头的，非常好用。

#### 文件树 支持
参考 SpaceVim 的[文档](https://spacevim.org/documentation/#file-tree)

#### 格式化文件
`Space` `r` `f` 格式化当前文件，仅仅支持C++/C 和 Rust。

## 配置源代码解释
SpaceVim 的文档往往是过时的或者是不相信的，如果想知道 defx 的使用方法，进入到 ~/.SpaceVim/ 中间，找到 defx.vim 直接阅读代码即可。

本项目的主要组成
0. init.toml : 最基本的配置，以及自定义的插件
1. autoload/myspacevim.vim : 一些插件的配置，一些快捷键
2. plugin/coc.vim : coc.nvim 和 ccls 的配置，几乎是[coc.nvim 标准配置](https://github.com/neoclide/coc.nvim#example-vim-configuration) 和 [ccls 提供给coc.nvim 的标准配置](https://github.com/MaskRay/ccls/wiki/coc.nvim) 的复制粘贴。

#### 其他杂项
1. `<F4>` 我自己写的一键运行文件，支持语言的单文件支持如 C/C++, Java, Rust等。
2. `<Space>` `l` `p` 预览markdown

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

## 其他的一些资源

主题
1. [dracula](https://draculatheme.com/vim/) 目前感觉最好看的主题之一
2. [vimcolors](http://vimcolors.com/) vim主题网站
3. [solarized](https://github.com/vim-scripts/Solarized) solarized

学习Vim的推荐网站
2. [Vim China](https://github.com/vim-china)
3. [vim galore](https://github.com/mhinz/vim-galore)

除了Spacevim之外，还有其他一些很有意思的框架，下面可以尝试一下。
1. [exvim](https://exvim.github.io/)
5. [github repo](https://github.com/spf13/spf13-vim)
6. [The Ultimate vimrc](https://github.com/amix/vimrc)

其他参考
1. https://github.com/habemus-papadum/kernel-grok
2. https://stackpointer.io/unix/linux-get-kernel-config/545/

转发 CSDN 按侵权追究法律责任，其它情况随意。
