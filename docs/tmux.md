# 极简 alacritty + tmux 配置
本文主要受 https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/ 启发的。

## alacritty
现在市面上有很多的 terminal emulator，比如:
- [Deepin](https://github.com/linuxdeepin/deepin-terminal)
- [tilix](https://gnunn1.github.io/tilix-web/)
- [kitty](https://sw.kovidgoyal.net/kitty/)

但是 [Alacritty](https://github.com/alacritty/alacritty) 是启动最为高效，简洁的一个。

对于 Alacritty 的配置也是非常简单的，具体可以参考: 
https://github.com/Martins3/My-Linux-Config/blob/master/scripts/alacritty.yml

## tmux
因为 Alacritty 默认不提供 window pane 的功能，当同时运行多个程序的时候，打开多个 alacritty 的操作就太笨重了。tmux 就可以用于创建多个 window 和 pane 的。

具体可以参考: https://github.com/Martins3/My-Linux-Config/blob/master/scripts/tmux.conf
这个脚本超级简单，而且每一个行都是有注释的。
## alacritty 的问题
在完成了一些基本的配置之后，alacritty 和 tmux 基本工作正常，但是输入法会在切换应用的时候 crash, 具体效果为，但是并无法使用相同的方法解决:
https://shawn233.github.io/2020/02/15/Fcitx-A-Strange-Bug-and-Its-Fix/

而是 alacritty 和程序的切换导致的，于是搜索到下面这个帖子:
1. https://wiki.gentoo.org/wiki/Alacritty
2. https://github.com/alacritty/alacritty/issues/3570

按照其方法，还是无法正确解决问题:
```sh
~> cat ~/.xinitrc
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
eval "$(dbus-launch --sh-syntax --exit-with-session)"

exec gnome
```

[检查 x11 还是 wayland](https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used)

因为 sougou 拼音的问题让 alacritty 非常的鬼畜
[也许禁用 ibus 是一种方法](https://zhuanlan.zhihu.com/p/142206571)
```sh
sudo dpkg-divert --package im-config --rename /usr/bin/ibus-daemon
```
