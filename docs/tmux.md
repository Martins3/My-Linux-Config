# 极简 Tmux 配置

如果一开始就阅读 [tmux 之道](https://leanpub.com/the-tao-of-tmux/read) 这种很厚的书，感觉这一辈子都不会入手的。
其实很多工具，尤其是类似 tmux vim 这种定制化很强的工具，我都是建议先用着再说，遇到问题再 stackoverflow，最后综合的雪鞋一下，
感觉学习曲线会平缓很多。

[Oh my tmux](https://github.com/gpakosz/.tmux) 我尝试过几分钟，但是个人默认配置不够简洁，高级功能暂时用不上，所以没有深入分析。

最简单的方法就是立刻使用起来，配置可以参考我个人的 [tmux.conf](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/tmux.conf) 配置
这个脚本超级简单，而且每一个行都是有注释的。

此外说明一下默认的常用技巧:
- `prefix d` : 等价于 tmux detach
- `prefix l` : 切换到 last window
- `prefix &` : kill 当前的 window

<script src="https://utteranc.es/client.js" repo="Martins3/My-Linux-Config" issue-term="url" theme="github-light" crossorigin="anonymous" async> </script>
