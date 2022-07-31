# Tabby, Tilix, Gnome Terminal, Alacritty 和 Kitty 使用体验对比

自己大多数时间都是在 terminal 中套上 tmux，然后其中打开 vim 工作的，其中切换过多次的 terminal ，在这里总结一下。

## Tabby

非常的酷炫，但是性能不行。

## Deepin Terminal

大约使用过 2  年（2016 -2018）的 Deepin OS ，发现内置的 terminal 也就是 Deepin Terminal 很好用，
可以非常容易的切换主题，半透明，容易使用的 tab 和 window 等功能。

## Tilix

Manjaro 的内置 terminal，大约使用了几个月，说实话，感觉没有什么特色。

## Gnome terminal

Gnome terminal 我也使用过非常长的时间，主要是因为在[龙芯平台上我编不出来 alacritty](https://martins3.github.io/loongarch/neovim.html) 以及有一段时间 alacritty 无法正确的

原来的 Gnome terminal 的配色我不是很喜欢，以及
为了让 terminal 一打开就会自动执行 tmux，需要在配置上进行一些[调整](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/gnome.dconf)

保存和加载配置的方法为(假设将本仓库 clone 到了 ~/.dotfils 上):
```sh
dconf dump /org/gnome/terminal/legacy/profiles:/:32d12ada-ed49-4c3d-8436-0f64853f7579/ > ~/.dotfiles/scripts/gnome.conf
dconf load /org/gnome/terminal/legacy/profiles:/:32d12ada-ed49-4c3d-8436-0f64853f7579/ < ~/.dotfiles/scripts/gnome.conf
```

gnome terminal d
- Ubuntu 修改默认 terminal emulator
```sh
sudo update-alternatives --config x-terminal-emulator
```

## Alacritty

对我而言，Alacritty 最大的改变在于，在一个大文件中，再也没有打字的延迟了。

我的 Alacritty 配置在[这里](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/alacritty.yml)，虽然非常的长，其实只是对于官方配置做了一些细小的调整，比如自动加载 tmux 之类的。

安装方法参考[官方文档](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
```sh
cargo build --release --no-default-features --features=x11
```

主要的改动为:
- 采用的颜色主题为 [`solarized_dark`](https://github.com/eendroroy/alacritty-theme/blob/master/themes/solarized_dark.yaml)
- 修改字体为 Hasklug Nerd Font
- 设置启动自动为 tmux

具体细节和 [官方默认配置](https://github.com/alacritty/alacritty/releases/download/v0.10.1/alacritty.yml) diff 一下就可以知道了。

## Kitty

切换到 Mac 之后，我发现 alacritty 的两个问题让人很痛苦:
- rime 输入法在输入的过程中无法显示已经输入的字母；
- 需要额外的精力处理 Alt 键；
- 没有 tab 的支持。

而且 kitty 支持 session 的概念，配置之后，每次 terminal 可以自动 attach 本地和远程 server 的 tmux 。

<script src="https://giscus.app/client.js"
        data-repo="Martins3/My-Linux-Config"
        data-repo-id="MDEwOlJlcG9zaXRvcnkyMTUwMDkyMDU="
        data-category="General"
        data-category-id="MDE4OkRpc2N1c3Npb25DYXRlZ29yeTMyODc0NjA5"
        data-mapping="pathname"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="en"
        crossorigin="anonymous"
        async>
</script>

本站所有文章转发 **CSDN** 将按侵权追究法律责任，其它情况随意。
