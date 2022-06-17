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
];
```

最后，执行 `nixos-install`，然后就是等待，最后你需要输入密码，这是 root 的密码。

我在这里踩的坑
- 在 QEMU 中 UEFI 暂时没有成功过，使用 legacy bios
- QEMU 的参数中不要增加 `-kernel`，否则无法正确启动，因为 Nix 对于内核版本也是存在管理的，所以不能随意指定

## 创建普通用户

使用 root 作为用户名和刚刚你设置的密码登录进去，执行如下命令

```sh
useradd -c 'martin three' -m martins3
passwd martins3 # 设置用户的密码
usermod -aG sudo username
reboot
```
- [ ] 这步操作有问题，导致 martins3 没有在 sudo files

## 初始化环境

导入本配置的操作:
```sh
cd ~
git clone https://github.com/Martins3/My-Linux-Config
ln ~/My-Linux-Config ~/.config/nixpkgs
```

修该 `/etc/nixos/configuration.nix`，让其 import `/home/martins3/.config/nixpkgs/system.nix`。**注意 martins3 改成你的用户名**

### 添加软件源
- [ ] 一定需要设置代理吗?

```sh
su -
nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixos # 对于NixOS
nix-channel --add https://mirror.tuna.tsinghua.edu.cn/nix-channels/nixos-21.11 nixpkgs # 对于Nix
# 添加home manager 源
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update
```

### 部署配置

```sh
su -
nixos-rebuild switch # 仅NixOS
```

### 部署 nixos 配置
```sh
# 安装home-manager
nix-shell '<home-manager>' -A install
home-manager switch
```

## 网络代理
似乎之要是 su - 之后添加 export 才会影响 sudo 命令的 export 吗 ?
每次进入之后都是需要增加代理的

## 遇到的问题
- file 'home-manager' was not found in the Nix search path
  - 只有更新来 channel 之后才可以安装 hoem manager
  - https://github.com/nix-community/home-manager/issues/487

## 记录
- [ ] 似乎只是 import 来一下 system.nix 之后，然后就感觉是完全的重新编译
- nix-shell -p htop
- 似乎 system.nix 中的清华镜像是有问题的
  - [ ] 对于 system.nix 的任何修改是不是都需要进行一次 nixos-rebuild switch
- /etc/nixos/configuration.nix 还是不要进行修改了

- [ ] 似乎是无法正确加载的 plugins.lua 的
- [ ] 好像需要调整 nvim 的 plugins 的

```sh
cat ~/.ssh/id_rsa.pub | ssh martins3:192.168.125.102 'cat >> .ssh/authorized_keys && echo "Key copied"'
```

- [ ] 测试 alacritty 的
- [ ] tmux 的测试
