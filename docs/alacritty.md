## 极简 Alacritty 配置

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
