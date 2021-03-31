# 自动安装脚本
- [ ] 利用 qemu 来构建 ci 测试
- [ ] 提供 tmux 以及 alacritty.yml 配置集成
  - [ ] alacritty 的安装需要按照其仓库的 ./install.md 的步骤手动编译


## alacritty
在完成了一些基本的配置之后，alacritty 和 tmux 基本工作正常，但是输入法会在切换应用（Alt+Tab）的时候 crash, 具体效果为，但是并无法使用相同的方法解决:
https://shawn233.github.io/2020/02/15/Fcitx-A-Strange-Bug-and-Its-Fix/

最终我忽然意识到，不是切换应用的时候出现问题，而是 alacritty 和程序的切换导致的，于是搜索到下面这个帖子:
1. https://wiki.gentoo.org/wiki/Alacritty
2. https://github.com/alacritty/alacritty/issues/3570

按照其方法，还是无法正确解决问题:
```
~> cat ~/.xinitrc
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
eval "$(dbus-launch --sh-syntax --exit-with-session)"

exec gnome
```

[检查 x11 还是 wayland](https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used)

## tmux
颜色设置: https://github.com/alacritty/alacritty/issues/3347

sec delay : https://github.com/neovim/neovim/issues/2035

tmux 基本 :
https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/
