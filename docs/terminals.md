# Tabby, Tilix, Gnome Terminal, Alacritty 和 Kitty 使用体验对比

目前我使用的是 kitty 。

<!-- vim-markdown-toc GitLab -->

* [Deepin Terminal: 2016-2018](#deepin-terminal-2016-2018)
* [Tilix: 2019](#tilix-2019)
* [Gnome terminal : 2020](#gnome-terminal-2020)
* [Alacritty : 2020-2022](#alacritty-2020-2022)
* [Kitty : 2022-现在](#kitty-2022-现在)
* [Tabby : 几分钟](#tabby-几分钟)
* [wezterm](#wezterm)
* [总结](#总结)

<!-- vim-markdown-toc -->

我是 2015 年开始学习计算机的，第一年使用的 Windows，只是使用的

## Deepin Terminal: 2016-2018

大约使用过 2  年（2016-2018）的 Deepin OS ，发现内置的 terminal 也就是 Deepin Terminal 很好用，
可以非常容易的切换主题，半透明，容易使用的 tab 和 window 等功能。

## Tilix: 2019

Manjaro 的内置 terminal，大约使用了几个月，之所以切换为 Tilix 是因为在 Manjaro 上无法成功安装 Deepin Terminal，
而不是因为比 Deepin Terminal 更好。

## Gnome terminal : 2020

Gnome terminal 我也使用过非常长的时间，主要是因为在[龙芯平台上我编不出来 alacritty](https://martins3.github.io/loongarch/neovim.html) 以及有一段时间 alacritty 无法正确的处理

原来的 Gnome terminal 的配色我不是很喜欢，以及
为了让 terminal 一打开就会自动执行 tmux，需要在配置上进行一些[调整](https://github.com/Martins3/My-Linux-Config/blob/master/config/gnome-terminal.dconf)

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

## Alacritty : 2020-2022

Alacritty 目前而言是我使用时间最长的 terminal 了，中间因为输入法的问题换成了 Gnome Terminal，后来解决之后，又切换回来了。

Alacritty 的优点:
- 对于 UI 可以高度的定制化，只是设置为真正的全屏模式
- 性能很好。

## Kitty : 2022-现在

切换到 Mac 之后，我发现 alacritty 的两个问题让人很痛苦:
- rime 输入法在输入的过程中无法显示已经输入的字母；
- 需要额外的精力处理 Alt 键；
- 没有 tab 的支持。

而且 kitty 支持 session 的概念，配置之后，每次 terminal 可以自动 attach 本地和远程 server 的 tmux 。

此外，kitty 的 log 是一只可爱的小猫咪，就凭这一点，我就直接给它打满分。

## Tabby : 几分钟

非常的酷炫，但是性能不行。

## wezterm

我发现我切换到 nixos 之后，kitty 中不能输入中文了，所以就换成了 [wezterm](https://github.com/wez/wezterm) 。
配置大约花费了半个消失，最后 tab 栏有点臭，其他还好。

<!-- @todo 不知道为什么，最下面有一大片空白的无法被 zellij 或者 nvim 填满 -->
## 总结
目前，我推荐的 terminal 是:
- kitty
- wezterm
- alacritty

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
