# 极简 Tmux 配置

其实我很长时间都是不使用 tmux 的，因为很多终端模拟器中已经包含了 Tab 和 Windows 的功能，但是使用了 tmux 之后，发现 tmux 非常灵活，尤其是在远程的 server 中使用。

## 先用起来再说
没有必要阅读 [tmux 之道](https://leanpub.com/the-tao-of-tmux/read) 这种很厚的书，会被直接劝退的。
其实很多工具，尤其是类似 tmux vim 这种定制化很强的工具，我都是建议先用着再说，遇到问题再 stackoverflow，最后综合的学习一下，
学习曲线会平缓很多。

[Oh my tmux](https://github.com/gpakosz/.tmux) 我尝试过几分钟，但是个人默认配置不够简洁，高级功能暂时用不上，所以没有深入分析。

最简单的方法就是立刻使用起来，配置可以参考我个人的 [tmux.conf](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/tmux.conf) 配置
这个脚本超级简单，而且每一个行都是有注释的。

## 默认常用操作
- `prefix d` : 等价于 tmux detach
- `prefix &` : kill 当前的 window
- `prefix x` : kill 当前的 pane
- `prefix R` : 重新加载配置

## 默认不怎么常用操作
- `prefix l` : 切换到 last window
- `prefix Space` : 切换下一个 pane layout
- `prefix z` : 最大化当前的 pane
- `prefix !` : 将 pane 转换为 window

## copy mode
默认可以编辑的状态 tmux 称为 normal mode，使用 `prefix y` 进入到 copy mode，进入之后，可以使用 vim 的各种移动方式

> Although tmux copy mode doesn't translate to 100% vim navigation keys - overall they are good enough to feel natural. Some navigation keys that you can use:
> - h / j / k / l to move left/down/up/right
> - w / W / e / E / b / B to move forward to the start / to the end / backward a word or WORD
> - { / } to move backward / forward a paragraph
> - Ctrl + e / d / f to scroll down a line / half screen / whole screen
> - Ctrl + y / u / b to scroll up a line / half screen / whole screen
> - / / ? to search forward / backward
> - n / N to repeat the previous search forward / backward
> etc
>
>  https://dev.to/iggredible/the-easy-way-to-copy-text-in-tmux-319g

- `V` 行选，`v` 字符选，`ctrl-v` 不支持
- [zt/zz/zb 没有支持](https://www.reddit.com/r/tmux/comments/5yoh1q/is_there_a_hack_to_have_vi_ztzzzb_in_copy_mode/)
- 使用 `y` 或者 `enter` 或者鼠标选中，可以复制
- 使用 `ctrl shift v` （MacOS 上 `ctrl-v`) 粘贴，这个和 tmux 无关，一般是 terminal emulator 支持的。

## 插件管理

安装:
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

- `prefix + I`
  - Installs new plugins from GitHub or any other git repository
  - Refreshes TMUX environment
- `prefix + U`
  - updates plugin(s)
- `prefix + alt + u`
  - remove/uninstall plugins not on the plugin list

## session 管理

通过 tmuxp 创建一个 session 并且自动执行初始化命令:

例如，如下命令可以自动创建两个 window 并且分别打开对应的仓库
```sh
tmuxp load -d ./tmux-session.yaml
```

cat tmux-session.yaml
```txt
session_name: note
windows:
  - window_name: org-mode
    layout: tiled
    shell_command_before:
      - cd ~/core/org-mode
      - nvim
  - window_name: .dotfiles
    layout: tiled
    shell_command_before:
      - cd ~/core/.dotfiles
      - nvim
```
## 配合 bash 使用

创建一个 session 并且让 fio 在启动运行:
```sh
tmux new-session -d -s my_session || true
tmux new-window -d "fio test.fio"
```

## 一些技巧
给每一个 tmux pane 设置标题:
```txt
set -g pane-border-status top
set -g pane-border-format " [ ###P #T ] "
bind T command-prompt -p "Set Pane title:" "select-pane -T '%1'"
```

## 最近遇到的 tmux 问题
- 有时候，nvim 报告 Clipboard 是 tmux，但是实际上下面的才是正确的
```txt
## Clipboard (optional)
  - OK: Clipboard tool found: xclip
```
- 登录远程终端，在远程终端中使用 clear 或者 vim 的时候遇到
```txt
'tmux-256color': unknown terminal type.
```
https://unix.stackexchange.com/questions/574669/clearing-tmux-terminal-throws-error-tmux-256color-unknown-terminal-type

## 一些试错

1. 自动连接远程的 server 的 tmux，这样就可以一次有一次使用 ssh 创建 remote terminal 了
```sh
ssh -t user@11.22.33.44 "tmux attach || /usr/bin/tmux"
```
当然，可以将这个行为定义为你的 terminal emulator (例如 ketty 或者 wezterm)的一个快捷键。

2. tmux list-keys 用于查看已经绑定的快捷键

2. tmux 的悬浮窗口
配置参考: https://gist.github.com/LintaoAmons/22f6184b26bd5b93d8fe9f9276f50f75
```txt
bind-key -n -N 'Toggle popup window' C-h if-shell -F '#{==:#{session_name},popup}' {
    detach-client
} {
    display-popup -d "#{pane_current_path}" -xC -yC -w 60% -h 75% -E "tmux attach-session -t popup || tmux new-session -s popup"
}
```
向比 zellij 好处是可以继续多开，但是问题是这会让 switch to next session 命令完全混乱了。
其实我们希望 popup 的是一个 pane 而不是 session 的。所以最后还是靠 nvim 的悬浮窗来解决问题吧。

3. 嵌套 tmux 是一个死亡深渊，没有必要尝试。
  - 如果在本地的一个 tmux 中嵌套，tmux 会直接警告你。
  - 但是你可以在本地 tmux，然后其中一个 pane 中链接远程，然后在其中开启 tmux，这给我带来了好几个问题。
    - 以前是 prefix c 可以创建一个窗口，为了给内层 tmux 创建一个窗口，现在需要按 prefix prefix c，当然也许修改 prefix 也可以。
    - 到底是进入的外层还是内层的 tmux 的 vi mode 也是经常搞混的事情。

## 扩展
- [tmuxinator](https://github.com/tmuxinator/tmuxinator) 可以实现 kitty 的 session 的管理
- [Tmux-Tutorial](https://leimao.github.io/blog/Tmux-Tutorial/)
  - https://news.ycombinator.com/item?id=21055468
- [catppuccin 主题](https://github.com/catppuccin/tmux)

## 教程
- https://leimao.github.io/blog/Tmux-Tutorial/

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
