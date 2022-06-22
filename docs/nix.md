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
  firefox
  zsh
];
```

最后，执行 `nixos-install`，然后就是等待，最后你需要输入密码，这是 root 的密码。

我在这里踩的坑
- 在 QEMU 中 UEFI 暂时没有成功过，使用 legacy bios
- QEMU 的参数中不要增加 `-kernel`，否则无法正确启动，因为 Nix 对于内核版本也是存在管理的，所以不能随意指定

## 初始化环境

使用 root 用户登录进去：

1. 设置用户密码
```sh
passwd sh
```


重新使用普通用户登入，密码为刚刚设置的:

1. 添加软件源
```sh
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixos # 对于NixOS
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixpkgs # 对于Nix
# 添加home manager 源
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
sudo nix-channel --update
```

2. 导入本配置的操作:
```sh
cd ~
git clone https://github.com/Martins3/My-Linux-Config
ln ~/My-Linux-Config ~/.config/nixpkgs
```
- 修该 `/etc/nixos/configuration.nix`，让其 import `/home/martin/.config/nixpkgs/system.nix`。**注意 martin 改成你的用户名**
- 你可能需要修改一下 system.nix 中的用户名

3. 初始化配置
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
```nix
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.05 nixos # 对于NixOS
sudo nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-22.05 nixpkgs # 对于Nix
# 添加home manager 源 sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
sudo nix-channel --update
```

## tmux 的测试
第一个插件需要手动安装，可以修复吗?

## [ ] python 插件

## [ ] nvim 中的 lightspeed 无法正确工作的呀

## [ ] 没有声音啊

## [ ] 下一步，还是阅读 Boom 吧，将其中的环境搭建起来

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

## [ ] 找到 Rust 类似的开发环境

## [ ] Rime 输入法
## [ ] i3 比我想想的要简单很多，值得尝试
https://github.com/denisse-dev/dotfiles/blob/main/.config/i3/config

## 一些同步技术
```sh
cat ~/.ssh/id_rsa.pub | ssh martins3:192.168.125.102 'cat >> .ssh/authorized_keys && echo "Key copied"'
```

rsync --delete -avzh --filter="dir-merge,- .gitignore" maritns3@10.0.2.2 ~/


https://martins3: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@github.com

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

## [ ] 测试 alacritty
- 为什么不是默认全屏的哇?https://github.com/denisse-dev/dotfiles/blob/main/.config/i3/config
  - 似乎如果将 -vga virtio 修改为 -vga std 就可以解决
- [ ] 不是半透明的了
