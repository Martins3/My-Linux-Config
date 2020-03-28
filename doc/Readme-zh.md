# Linux 命令行生存指南

这是我个人使用Linux的三篇笔记中的第二篇:
第一篇 : 记录一般生活软件的安装，比如输入法，微信，Tim等，这一步解决在Linux 下的生存问题。
第二篇 : 基本命令行的使用，利用好Linux 的优势。
第三篇 : vim配置，实现高效的写代码。

> 下面的内容是自己的看法，其中部分内容可能比较肤浅。

## 不要迷信命令行
为什么需要命令行:
1. 远程登录(这不是一个绝对的原因，但是图形界面的传输速度相对来说太慢了)。
2. 该程序没有图形界面版本。

为什么不需要命令行:
1. 命令行难以记忆。

我为什么使用命令行:
1. 经常使用命令数量是有限的，可以 [alias](https://askubuntu.com/questions/31216/setting-up-aliases-in-zsh) 这些命令
2. 过多的窗口让人让人手忙脚乱，在终端中间执行程序显得更加整洁。

## shell学习
1. https://devhints.io/bash  : 语法清单
2. https://explainshell.com/ : 解释脚本
3. https://linuxjourney.com/ : 免费教程

shell 和 gnu make, cmake 等各种工具类似，一学就会，学玩就忘。究其原因，是因为使用频率太低了。 如果你每天都要用，我建议，系统学习，如果只是偶尔学习，对于shell只需要存在一个大致的了解，就是知道shell能做什么，适合做什么，具体的知识点等到遇到的时候再到Google上查询。

## 选择一个好用的终端
一个好用的终端至少应该具有一下特性:
1. 多tab
2. 多窗口
3. 半透明
4. 性能

下面是一些有名的终端，我个人比较喜欢使用其中的 Deepin Terminal。

- [Deepin](https://github.com/linuxdeepin/deepin-terminal)
- [tilix](https://gnunn1.github.io/tilix-web/)
- [kitty](https://sw.kovidgoyal.net/kitty/)
- [hyper](https://hyper.is/)
- [Alacritty](https://github.com/alacritty/alacritty)

## 选择好用的shell
zsh 和 bash 之前语法上基本是兼容的，但是由于[oh my zsh](https://github.com/ohmyzsh/ohmyzsh)，我强烈推荐使用zsh

## git tricks 
lg

diff beautiful diff 

## 常用工具的替代
使用Linux有个非常窒息的事情在于，默认的工具使用体验一般，下面介绍一些体验更加的工具。

这些工具都是基本是从github awesome 和 hacker news 中间找到:

1. https://github.com/agarrharr/awesome-cli-apps
2. https://github.com/alebcay/awesome-shell
3. https://github.com/unixorn/awesome-zsh-plugins
4. https://news.ycombinator.com/ 

#### cd -> [autojump](https://github.com/wting/autojump)
使用命令行，如果没有 autojump ，我认为几乎是没有办法生存的。

autojump 没有学习曲线，只需要 j + 目标文件名的字符

#### ls -> [lsd](https://github.com/Peltoche/lsd)
效果对比如下:


#### du -> [ncdu](https://dev.yorhel.nl/ncdu)

du 的效果：
```
➜  .SpaceVim.d git:(master) ✗ /usr/bin/du 
28	./UltiSnips
32	./doc
12	./spell
12	./install
16	./plugin
36	./.git/objects/52
44	./.git/objects/9f
24	./.git/objects/ed
188	./.git/objects/77
60	./.git/objects/14
36	./.git/objects/6a
48	./.git/objects/f6
40	./.git/objects/80
// ... 省略
```

ncdu 的效果:
```
ncdu 1.14.2 ~ Use the arrow keys to navigate, press ? for help                                                                               
--- /home/shen/.SpaceVim.d ------------------------------------------------------------------------------------------------------------------
    9.9 MiB [##########] /.git                                                                                                               
   60.0 KiB [          ]  antigen.zsh
   32.0 KiB [          ] /doc
   28.0 KiB [          ] /UltiSnips
   16.0 KiB [          ] /plugin
   12.0 KiB [          ] /install
   12.0 KiB [          ] /autoload
   12.0 KiB [          ] /spell
    8.0 KiB [          ]  init.toml
    8.0 KiB [          ]  zshrc
    4.0 KiB [          ]  Readme.md
    4.0 KiB [          ]  gitconfig
    4.0 KiB [          ]  .netrwhist
    4.0 KiB [          ]  .profile
    4.0 KiB [          ]  .yaourtrc
    4.0 KiB [          ]  .gitignore
```

#### gdb 封装
1. [gdb dashboard](https://github.com/cyrus-and/gdb-dashboard)

#### git 封装
1. [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
2. [lazy git](https://github.com/jesseduffield/lazygit)
