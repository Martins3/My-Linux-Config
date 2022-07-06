# NixOS in QEMU

运行参考[我写的脚本](https://github.com/Martins3/My-Linux-Config/scripts/nix.sh)

## 1 安装系统
参考[官方教程](https://nixos.org/manual/nixos/stable/index.html#sec-installation) 以及
[这个解释](https://www.cs.fsu.edu/~langley/CNT4603/2019-Fall/assignment-nixos-2019-fall.html)


创建分区，安装操作系统，并且初始化 nixos
```sh
sudo -i
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MiB 100%
mkfs.ext4 -L nixos /dev/sda1
mount /dev/disk/by-label/nixos /mnt
nixos-generate-config --root /mnt
```

打开配置，需要进行两个简单的修改
```sh
vim /mnt/etc/nixos/configuration.nix
```

1. 注释掉这个从而可以使用 grub
```sh
boot.loader.grub.device = "/dev/sda";
```
2. 添加基本的工具方便之后使用
```nix
environment.systemPackages = with pkgs; [
  vim
  git
  wget
  zsh
];
```

最后，执行 `nixos-install`，然后就是等待，最后你需要输入密码，这是 root 的密码。

我在这里踩的坑
- 在 QEMU 中 UEFI 暂时没有成功过，使用 legacy bios
- QEMU 的参数中不要增加 `-kernel`，否则无法正确启动，因为 Nix 对于内核版本也是存在管理的，所以不能随意指定

## 初始化环境

使用 root 用户登录进去：


<!-- 1. 设置用户密码 -->
<!-- ```sh -->
<!-- useradd -c 'martins three' -m martins3 -->
<!-- passwd martins3 -->
<!-- ``` -->
<!-- 2. 切换到普通用户 -->
<!-- ```sh -->
<!-- su -l martins3 -->
<!-- ``` -->

2. 导入本配置的操作:
```sh
cd ~
git clone https://github.com/Martins3/My-Linux-Config
ln ~/My-Linux-Config ~/.config/nixpkgs
```

3. 重新进入到 sudo 中
```
su -
```

4. 执行 ./scripts/nix-channel.sh 切换源
```sh
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.05 nixos # 对于NixOS
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.05 nixpkgs # 对于Nix
# 添加home manager 源
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
sudo nix-channel --update
```

5. 修该 `/etc/nixos/configuration.nix`，让其 import `/home/martin/.config/nixpkgs/system.nix`。**注意 martins3 改成你的用户名**

6. 初始化配置
```sh
sudo nixos-rebuild switch # 仅NixOS
```

### 部署 nixos 配置
```sh
# 安装home-manager
nix-shell '<home-manager>' -A install
home-manager switch
```

此处踩的坑，即使是修改了 alacritty.yml 也是需要重新编译的。

### 更新 Nixos
和设置源相同

## [ ] python 插件
python virtual env 如何构建

https://akrabat.com/creating-virtual-environments-with-pyenv/

## [ ] microsoft-edge-dev 有时候会崩溃，也许切换一下版本吧
- 切换版本没用的啊

## [ ] clash
好吧，clash 尚未成功

> 手动将机场提供 clash 的 config.yaml 放在`~/.config/clash/config.yaml`即可。

## [ ] coc-Lua 的插件工作的不正常啊
- 似乎是动态库不能正确加载的
- [ ] 似乎只是需要重新编译就可以了

## [ ] 能不能在 Mac OS 的虚拟机中构建出来这个虚拟机环境

## wm
这个是一个非常通用的问题了，那就是插件下载的二进制是无法使用的

```sh
git clone --depth 1 https://github.com/manilarome/the-glorious-dotfiles/
```
这个就

```sh
git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git
mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome; rm -rf awesome-copycats
```

- 其中存在很多小问题需要进行修复的。
  - 好的，已经被我修复了: https://github.com/lcpz/lain/issues/503

## [ ] TODO
- 搭建 Boom 的阅读环境
- 搭建 Rust 的开发环境

## alacritty
- 为什么不是默认全屏的哇? https://github.com/denisse-dev/dotfiles/blob/main/.config/i3/config
  - 似乎如果将 -vga virtio 修改为 -vga std 就可以解决

## cpp
- https://blog.galowicz.de/2019/04/17/tutorial_nix_cpp_setup/
- https://www.breakds.org/post/nix-based-c++-workflow/
- https://nixos.wiki/wiki/C

别人也遇到了类似的问题:
- https://github.com/NixOS/nixpkgs/issues/9230
- https://www.reddit.com/r/NixOS/comments/vft54v/cmake_not_finding_boost_as_a_library/

所以这才是正确的操作吗?
https://www.reddit.com/r/NixOS/comments/fdi3jb/gcc1_doesnt_work_gives_weird_internalish_errors/

似乎这个东西叫做 user environment:
https://nixos.wiki/wiki/User_Environment

https://xieby1.github.io/scripts/index.html

```sh
nix-shell '<nixpkgs>' -A lua --command zsh
```

## 一些同步技术
```sh
cat ~/.ssh/id_rsa.pub | ssh martins3:192.168.125.102 'cat >> .ssh/authorized_keys && echo "Key copied"'
```

rsync --delete -avzh --filter="dir-merge,- .gitignore" maritns3@10.0.2.2 ~/

## nvim
安装到此处就可以了:
/home/maritns3/.local/share/nvim/site/pack/packer/opt/packer.nvim

## 在 QEMU 中，似乎无法正确的执行 setxkbmap

似乎需要 QEMU grab 进去才可以的

## 如何安装 microsoft-edge
- https://matthewrhone.dev/nixos-edge-browser

https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/
```sh
nix hash-file --sri microsoft-edge-dev_xx.xx.xx.xx-1_amd64.deb
```

实际上需要看这个东西:
https://gitlab.com/zanc/overlays/-/blob/master/edge/update.sh

## 为什么无法代理
- 大写
- nload 检查一下网速

wget 可以，但是 nerdfont 安装的过程中，github 中资源无法正确下载。

因为下载是使用 curl 的，但是如果不添加 -L 似乎是不可以的

## 没有声音啊
使用直通解决吧

## tmux 的测试
第一个插件需要手动安装，可以修复吗?
- 当然是可以的，但是没必要

## nix-prefetch-url 可以同时下载和获取 sha

## 桌面环境
- [ ] i3 比我想想的要简单很多，值得尝试
https://github.com/denisse-dev/dotfiles/blob/main/.config/i3/config
- [ ] 也许还是使用 awesome 吧

git clone https://github.com/leftwm/leftwm-theme

## [ ] 为什么默认是 bash 的环境

## sublime merge 的安装
- 开箱就得到了一个更新提示
  - 既然如此，可以总是只有部分软件使用 unstable 的，例如 neovim 的

## [x] 为什么直通只有左边的耳机才有声音啊
- 真的需要添加四个设备吗?
  - 有的似乎根本不相关啊
- q35 导致的

## [x] 每次启动都是需要 30s 的时间

```txt
➜  ~ sudo systemctl status dhcpcd.service
[sudo] password for martin:
● dhcpcd.service - DHCP Client
     Loaded: loaded (/etc/systemd/system/dhcpcd.service; enabled; vendor preset>
     Active: active (running) since Fri 2022-06-24 10:16:48 CST; 3min 31s ago
    Process: 783 ExecStart=dhcpcd --quiet --config /nix/store/23mah319pvq76qvn4>
   Main PID: 793 (dhcpcd)
         IP: 3.7K in, 0B out
         IO: 472.0K read, 0B written
      Tasks: 4 (limit: 9529)
     Memory: 1.5M
        CPU: 47ms
     CGroup: /system.slice/dhcpcd.service
             ├─793 "dhcpcd: [manager] [ip4] [ip6]"
             ├─794 "dhcpcd: [privileged proxy]"
             ├─795 "dhcpcd: [network proxy]"
             └─796 "dhcpcd: [control proxy]"

Jun 24 18:16:17 nixos systemd[1]: Starting DHCP Client...
Jun 24 18:16:17 nixos dhcpcd[783]: dhcpcd-9.4.1 starting
Jun 24 18:16:17 nixos dhcpcd[794]: dev: loaded udev
Jun 24 18:16:17 nixos dhcpcd[794]: DUID 00:01:00:01:2a:3f:0d:23:52:54:00:12:34:>
Jun 24 18:16:17 nixos dhcpcd[783]: no valid interfaces found
Jun 24 18:16:17 nixos dhcpcd[794]: no valid interfaces found
Jun 24 10:16:48 nixos dhcpcd[794]: timed out
```

增加这个也是没用的:
```nix
  networking.interfaces.enp0s2.useDHCP = true;
```

关键参考:
- https://www.reddit.com/r/NixOS/comments/pglkii/system_starts_really_slowly_because_of_one_process/

原来是不能切换主板为 q35, 怀疑是因为安装时候的主板和之后执行的主板不能切换.

## Rime 输入法
```sh
git clone https://github.com/rime/plum
cd plum
rime_dir="$HOME/.local/share/fcitx5/rime" bash rime-install
```
- `rime_dir` 的设置参考这里: https://wiki.archlinux.org/title/Rime

参考 [这篇 blog](http://t.zoukankan.com/jrri-p-12427956.html) 通过配置 fcitx5 的 UI
