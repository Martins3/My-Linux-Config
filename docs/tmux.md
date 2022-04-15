# 极简 Tmux 配置

其实我很长时间都是不使用 tmux 的,感觉 deepin-terminal 的 window 基本够用了,导致我发生转变的是 alacritty,因为这个 terminal emulator 没有 window 的功能.
但是,一旦开始使用上 tmux, 我只能说相见恨晚.

## 先用起来再说
如果一开始就阅读 [tmux 之道](https://leanpub.com/the-tao-of-tmux/read) 这种很厚的书，感觉这一辈子都不会入手的。
其实很多工具，尤其是类似 tmux vim 这种定制化很强的工具，我都是建议先用着再说，遇到问题再 stackoverflow，最后综合的学习一下，
感觉学习曲线会平缓很多。

[Oh my tmux](https://github.com/gpakosz/.tmux) 我尝试过几分钟，但是个人默认配置不够简洁，高级功能暂时用不上，所以没有深入分析。

最简单的方法就是立刻使用起来，配置可以参考我个人的 [tmux.conf](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/tmux.conf) 配置
这个脚本超级简单，而且每一个行都是有注释的。

## 默认常用操作
- `prefix d` : 等价于 tmux detach
- `prefix l` : 切换到 last window
- `prefix &` : kill 当前的 window
- `prefix x` : kill 当前的 pane

## copy mode
使用 `prefix y` 进入到 copy mode，进入之后，可以使用 vim 的各种移动方式[^1]

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

- 使用 `v`, `V` 和 `Ctrl v` 分别实现字符选，行选，块选
- 使用 `y` 复制
- 使用 `ctrl shift v` 粘贴，这个和 tmux 无关，一般是 terminal emulator 支持的

当然,如果感觉太麻烦,使用鼠标选中之后,也是自动复制出来的.

## 插件
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## 定制 statusline
感觉没必要，浪费时间

## 一些小技巧

1. 自动连接远程的 server 的 tmux，这样就可以一次有一次使用 ssh 创建 remote terminal 了
```sh
ssh -X -t user@11.22.33.44 "tmux attach || /usr/bin/tmux"
```

使用 -X 是远程的剪切板和本地是同步的，但是需要在远程机器上的一点点设置。
https://superuser.com/questions/806637/xauth-not-creating-xauthority-file

<script src="https://utteranc.es/client.js" repo="Martins3/My-Linux-Config" issue-term="url" theme="github-light" crossorigin="anonymous" async> </script>

[^1]: [zt/zz/zb 似乎没有支持](https://www.reddit.com/r/tmux/comments/5yoh1q/is_there_a_hack_to_have_vi_ztzzzb_in_copy_mode/)
