# 极简 Tmux 配置

## Tmux
如果一开始就阅读 [tmux 之道](https://leanpub.com/the-tao-of-tmux/read) 这种很厚的书，感觉
这一辈子都不会入手的。

[Oh my tmux](https://github.com/gpakosz/.tmux) 我尝试过几分钟，但是个人默认配置不够简洁，高级功能暂时用不上，所以没有深入分析。

最简单的方法就是立刻使用起来，配置可以参考我个人的 [tmux.conf](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/tmux.conf) 配置
这个脚本超级简单，而且每一个行都是有注释的。

## Alacritty
对我而言，Alacritty 最大的改变在于，在一个大文件中，再也没有打字的延迟了。

我的 Alacritty 配置在[这里](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/alacritty.yml)，虽然非常的长，其实只是对于官方配置做了一些细小的调整，比如自动加载 tmux 之类的。

安装方法参考[官方文档](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
```sh
cargo build --release --no-default-features --features=x11
```

主要的改动为:
- 采用的颜色主题为 [solarized_dark](https://github.com/eendroroy/alacritty-theme/blob/master/themes/solarized_dark.yaml)
- 修改字体为 Hasklug Nerd Font
- 设置启动自动为 tmux

具体细节和 [官方默认配置](https://github.com/alacritty/alacritty/releases/download/v0.10.1/alacritty.yml) diff 一下就可以知道了。

## 其他的记录
- Ubuntu 修改默认 terminal emulator
```c
sudo update-alternatives --config x-terminal-emulator
```

### Gnome terminal
Gnome terminal 我也使用过非常长的时间，这里记录一下主要是因为在[龙芯平台上我编不出来 alacritty](https://martins3.github.io/loongarch/neovim.html)

原来的 Gnome terminal 的配色我不是很喜欢，以及
为了让 terminal 一打开就会自动执行 tmux，需要在配置上进行一些[调整](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/gnome.dconf)

保存和加载配置的方法为(假设将本仓库 clone 到了 ~/.dotfils 上):
```sh
dconf dump /org/gnome/terminal/legacy/profiles:/:32d12ada-ed49-4c3d-8436-0f64853f7579/ > ~/.dotfiles/scripts/gnome.conf
dconf load /org/gnome/terminal/legacy/profiles:/:32d12ada-ed49-4c3d-8436-0f64853f7579/ < ~/.dotfiles/scripts/gnome.conf
```

<script src="https://utteranc.es/client.js" repo="Martins3/My-Linux-Config" issue-term="url" theme="github-light" crossorigin="anonymous" async> </script>
