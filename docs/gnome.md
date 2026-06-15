## switch caps 和 escape

https://unix.stackexchange.com/questions/377600/in-nixos-how-to-remap-caps-lock-to-control

似乎需要:

```sh
gsettings reset org.gnome.desktop.input-sources xkb-options
gsettings reset org.gnome.desktop.input-sources sources
```

也许也需要执行下:
setxkbmap -option caps:swapescape


gnome 中的最终解决方案:
```sh
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
```

## 快捷键配置

```sh
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Control>1']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Control>2']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Control>3']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Control>4']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-windows "['<Control>l']"
```

## 键盘重复延迟原来是 500ms，
```sh
gsettings set org.gnome.desktop.peripherals.keyboard delay 200
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 18
```
