## switch caps 和 escape

https://unix.stackexchange.com/questions/377600/in-nixos-how-to-remap-caps-lock-to-control

```sh
gsettings reset org.gnome.desktop.input-sources xkb-options
gsettings reset org.gnome.desktop.input-sources sources
```
也许也需要执行下:
setxkbmap -option caps:swapescape

2026-07-17 : 上面的方法可以不看，gnome 中的最终解决方案:
```sh
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
```

## fn 映射为 ctrl (Asahi Linux)

fn 的 keycode 是 464 (KEY_FN)，超出 xkb 能处理的 8-255 范围，xkb-options/gsettings 对 fn 无效。
udev hwdb 也不行: Asahi 的 SPI 键盘设备没有 MODALIAS udev 属性
(`udevadm info -q property /dev/input/eventX` 看不到)，
udev keyboard builtin 无法构造 hwdb 查询串，规则永远不会命中。
keyd 可以做，但 Fedora aarch64 官方源没有打包，需要源码编译。

正确做法: 键盘驱动是 hid_apple，自带 `swap_fn_leftctrl` 参数，在驱动层交换 fn 和左 ctrl:

```sh
echo "options hid_apple swap_fn_leftctrl=1" | sudo tee /etc/modprobe.d/hid_apple.conf
```

重启后生效。不重启立即生效 (键盘会断开重连一秒):

```sh
echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_fn_leftctrl
echo "0019:05AC:0354.0003" | sudo tee /sys/bus/hid/drivers/apple/unbind
echo "0019:05AC:0354.0003" | sudo tee /sys/bus/hid/drivers/apple/bind
```

其中设备 id 用 `ls /sys/bus/hid/drivers/apple/` 确认。


```txt
options hid_apple swap_fn_leftctrl=1 swap_opt_cmd=2
```

在 Fedora Asahi Remix 43 (MacBook Pro, Apple MTP keyboard 05AC:0354) 上验证通过。

注意:

- 这是交换: 左下角 fn 变成左 ctrl，原来的左 ctrl 变成 fn
- 因为交换发生在驱动层，左 ctrl (现在是 fn) 拥有真正的 fn 功能，
  按住它 F 区的亮度等转换照常工作
- 右 option 映射为 fn 做不到: hid_apple 不支持，keyd 虽能发出 KEY_FN
  但不参与驱动的 F 区转换，没有实际用途
- 其他 hid_apple 参数: fnmode, swap_opt_cmd, swap_ctrl_cmd，
  见 `ls /sys/module/hid_apple/parameters/`
- 和 GNOME 的 caps:swapescape 不冲突，两者可以共存

## 快捷键配置

```sh
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Control>1']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Control>2']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Control>3']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Control>4']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-windows "['<Control>l']"
```

## 键盘重复延迟原来是 500ms
```sh
gsettings set org.gnome.desktop.peripherals.keyboard delay 200
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 18
```
