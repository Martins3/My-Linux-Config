# 极简 Gnome terminal + tmux 配置

## tmux
如果一开始就阅读 [tmux 之道](https://leanpub.com/the-tao-of-tmux/read) 这种很厚的书，感觉
这一辈子都不会入手的。

最简单的方法就是立刻使用起来，配置可以参考我个人的 [tmux.conf](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/tmux.conf) 配置
这个脚本超级简单，而且每一个行都是有注释的。

## Gnome terminal
原来的 Gnome terminal 的配色我不是很喜欢，以及
为了让 terminal 一打开就会自动执行 tmux，需要在配置上进行一些[调整](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/gnome.dconf)

保存和加载配置的方法为:
```sh
dconf dump /org/gnome/terminal/legacy/profiles:/:32d12ada-ed49-4c3d-8436-0f64853f7579/ > ~/.SpaceVim.d/scripts/gnome.dconf
dconf load /org/gnome/terminal/legacy/profiles:/:32d12ada-ed49-4c3d-8436-0f64853f7579/ < ~/.SpaceVim.d/scripts/gnome.dconf
```

<script src="https://utteranc.es/client.js" repo="Martins3/My-Linux-Config" issue-term="url" theme="github-light" crossorigin="anonymous" async> </script>
