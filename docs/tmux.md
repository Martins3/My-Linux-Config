# 极简 Gnome terminal + tmux 配置

## tmux
具体可以[参考源码](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/tmux.conf)
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
