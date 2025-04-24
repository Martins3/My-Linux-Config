# NixOS 初步尝试

声明：

- NixOS 是给程序员准备的，你甚至需要掌握一门新的函数式编程语言。
- 其次，NixOS 的入门曲线非常的陡峭。

我在使用 NixOS 的时候，一度想要放弃，最终勉强坚持下来了。

之所以坚持使用 NixOS ，是因为我感觉 NixOS 非常符合计算机的思维，
那就是**相同的问题仅仅解决一次**，而这个问题是 环境配置。

## 安装

### 在命令行中安装

#### 手动分区

参考[官方教程](https://nixos.org/manual/nixos/stable/index.html#sec-installation) 以及

创建分区，安装操作系统，并且初始化 nixos

因为是在 QEMU 中，所以暂时使用的 MBR 的分区，而不是 GPT

```sh
sudo -i
parted /dev/vda -- mklabel msdos
parted /dev/vda -- mkpart primary 1MiB -20GB
parted /dev/vda -- mkpart primary linux-swap -20GB 100%
mkfs.ext4 -L nixos /dev/vda1
mount /dev/disk/by-label/nixos /mnt
mkswap -L swap /dev/vda2
swapon /dev/vda2
nixos-generate-config --root /mnt
```

打开配置 /mnt/etc/nixos/configuration.nix 中实现 uefi 启动，并且含有 grub

```nix
 # 将这行注释掉
 # boot.loader.systemd-boot.enable = true;

 # 如果是虚拟机，增加下如下内容
 # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
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

最后，执行 `nixos-install`，然后就是等待，最后你需要输入密码，这是 root 的密码，然后重启，进入下一个阶段。

我在这里踩的坑

- 在 QEMU 中 UEFI 暂时没有成功过，使用 legacy bios
- QEMU 的参数中不要增加 `-kernel`，否则无法正确启动，因为 Nix 对于内核版本也是存在管理的，所以不能随意指定

#### 安装系统

使用 root 用户登录进去：

1. 创建 martins 用户，主要是为了创建 /home/martins3 目录出来

```sh
useradd -c 'martins three' -m martins3
su -l martins3
```

3. 导入本配置的操作:

```sh
git clone https://github.com/Martins3/My-Linux-Config
git checkout feat
```

执行 ./scripts/install.sh 将本配置的文件软链接的位置。

4. su
5. 执行 ./scripts/nixos-install.sh

6. 切换为 martins3，开始部署 home-manager 配置

```sh
# 安装home-manager
nix-shell '<home-manager>' -A install
home-manager switch
```

### 在图形界面的安装

1. [2.2. Graphical Installation](https://nixos.org/manual/nixos/stable/index.html#sec-installation-graphical) : 建议图形化安装
   遇到网络问题，执行如下内容

```sh
sudo chmod +w /etc/nixos/configuration.nix
sudo vim /etc/nixos/configuration.nix
# 在配置中增加上
# networking.proxy.default = "http://192.168.64.62:8889"; # 需要提前搭梯子
sudo nixos-rebuild
```
逆天，这里居然也是会存在问题的，正是鸡生蛋，蛋生鸡的问题。

2. 重启

<-- 这里我们使用了一个备份，直接用吧

3. 首先解决网络问题，使用 nano 将 /etc/nixos/configuration.nix 中的 networking.proxy 的两个配置修改正确。
4. 打开 shell，执行 `nix-shell -p vim git` ，然后

```sh
git clone https://github.com/Martins3/My-Linux-Config .dotfiles
# nixos 的安装
sudo /home/martins3/.dotfiles/scripts/nixos-install.sh
# 其他的工具的安装
/home/martins3/.dotfiles/scripts/install.sh
```

最开始的时候无法 ssh ，所以以上操作都需要在图形界面中操作。

## 高级

### 关于 reproducible build

- https://docs.kernel.org/kbuild/reproducible-builds.html
- https://news.ycombinator.com/item?id=19310638
- https://tests.reproducible-builds.org/archlinux/archlinux.html

## 常见操作

- nix-prefetch-url 同时下载和获取 hash 数值

```sh
nix-prefetch-url https://github.com/Aloxaf/fzf-tab
```

- nixos 默认是打开防火墙的
  - https://nixos.org/manual/nixos/unstable/options.html#opt-networking.firewall.enable
- NixOS 半年更新一次，更新 Nixos 和设置源相同，更新 NixOS 之后可能发现某些配置开始报错，但是问题不大，查询一下社区的相关文档一一调整即可。
- 查询 nixos 的包和 options : https://search.nixos.org/packages
- 安装特定版本，使用这个网站: https://lazamar.co.uk/nix-versions/
## 自动环境加载

- 使用了 [direnv](https://github.com/zsh-users/zsh-autosuggestions) 自动 load 环境，对于有需要路径上进行如下操作:

```sh
echo "use nix" >> .envrc
direnv allow
```

## npm 包管理

- https://stackoverflow.com/questions/56813273/how-to-install-npm-end-user-packages-on-nixos

之后，安装无需使用 sudo 了

```sh
npm install -g @lint-md/cli@beta
# npm i -g bash-language-server
# npm install -g vim-language-server
npm install -g prettier
# npm install -g @microsoft/inshellisense
```

## 共享

### 使用 samba 实现目录共享

参考配置: https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6

此外，在 Linux 中设置

```sh
sudo smbpasswd -a martins3
```

在 windows 虚拟机中，打开文件浏览器, 右键 `网络`，选择 `映射网络驱动器`，在文件夹中填写路径 `\\10.0.0.2\public` 即可。
注意，这里的 public 和配置文件中对应的。

如果遇到需要密码的时候，但是密码不对

```txt
sudo smbpasswd -a martins3
```

在 windows 那一侧使用 martins3 和新设置的密码来登录。

#### fedora 上 enable
将 fedora 的文件 贡献给 windows

```sh
sudo dnf install samba
sudo systemctl enable smb --now
```

sudo smbpasswd -a martins3

在 /etc/samba/smb.conf 的结尾地方添加:
```txt
[public]
        path = home/martins3/core
        browseable = yes
        read only = no
        guest ok = yes
```
总体来说，失败，一会儿再去尝试吧

### syncthing

强烈推荐，相当于一个自动触发的 rsync ，配置也很容易:

- https://wes.today/nixos-syncthing/
- https://nixos.wiki/wiki/Syncthing

使用注意项，可以在两个机器中编辑同一个文件夹中的文件，但是注意不要同时多个机器上编辑同一个文件，否则存在冲突。

## python

```txt
pip3 install http # 会提示你，说无法可以安装 python39Packages.pip
nix-shell -p python39Packages.pip # 好的，安装了
pip install http # 会提升你，需要安装 setuptools
pip install setuptools # 结果 readonly 文件系统
```

参考[这里](https://nixos.wiki/wiki/Python) 在 home/cli.nix 中添加上内容，但是会遇到这个问题，

```nix
  home.packages = with pkgs; [
```

正确的解决办法是，之后，就按照正常的系统中使用 python:

```sh
python3 -m venv .venv
source .venv/bin/activate
```

看看这个 https://github.com/astral-sh/uv

## [ ] cpp

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

## kernel

- https://nixos.wiki/wiki/Linux_kernel
- https://nixos.wiki/wiki/Kernel_Debugging_with_QEMU
- https://nixos.org/manual/nixos/stable/#sec-kernel-config

总体来说，构建

- 从哪里获取到 debuginfo ，如果可以获取，那么就可以使用 crash 来实现实时系统的分析
- drgn 无法安装，使用也是未知

## pkgs.stdenv.mkDerivation 和 pkgs.mkShell 的区别是什么

- https://discourse.nixos.org/t/using-rust-in-nix-shell-mkderivation-or-mkshell/15769

> For ephemeral environments mkShell is probably easier to use, as it is meant to be used just for this.
>
> If you though have something you want to build and want to derive an exact build environment without any extras from it, then use mkDerivation to build the final package and get the Dev env for free from it.

- https://ryantm.github.io/nixpkgs/builders/special/mkshell/

> pkgs.mkShell is a specialized stdenv.mkDerivation that removes some repetition when using it with nix-shell (or nix develop).

## 代理

https://yacd.metacubex.one/#/proxies

## 交叉编译

参考:

- https://xieby1.github.io/Distro/Nix/cross.html
- https://ianthehenry.com/posts/how-to-learn-nix/cross-compilation/

## tmux

为了让 tmux 配置的兼容其他的 distribution ，所以 tpm 让 nixos 安装，而剩下的 tmux 插件由 tmp 安装。

## gui

虽然暂时没有 gui 的需求，但是还是收集一下，以后在搞:

- [reddit : i3, polybar rofi](https://www.reddit.com/r/NixOS/comments/wih19c/ive_been_using_nix_for_a_little_over_a_month_and/)

## 安装 unstable 的包

一种方法是:

```nix
  /* google-chrome-stable = pkgs.callPackage ./programs/google-chrome-stable.nix {}; */
  nixpkgs_unstable = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/ac608199012d63453ed251b1e09784cd841774e5.tar.gz";
      sha256 = "0bcy5aw85f9kbyx6gv6ck23kccs92z46mjgid3gky8ixjhj6a8vr";
    })
    { config.allowUnfree = true; };
```

但是更加简单的是直接 install :

- https://www.joseferben.com/posts/installing_only_certain_packages_form_an_unstable_nixos_channel/

## [ ] 如何安装 tarball 的包

按照 https://unix.stackexchange.com/questions/646319/how-do-i-install-a-tarball-with-home-manager
的提示，
rnix-lsp 可以，但是 x86-manpages 不可以

## gcc 和 clang 是冲突的

- https://github.com/nix-community/home-manager/issues/1668
  - https://nixos.wiki/wiki/Using_Clang_instead_of_GCC
  - 无法同时安装 gcc 和 clang

## blog

[Are We Getting Too Many Immutable Distributions?](https://linuxgamingcentral.com/posts/are-we-getting-too-many-immutable-distros/)

[打个包吧](https://unix.stackexchange.com/questions/717168/how-to-package-my-software-in-nix-or-write-my-own-package-derivation-for-nixpkgs)

## tutorial

### nix pill

- https://nixos.org/guides/nix-pills/index.html

### how to learn nix

- https://ianthehenry.com/posts/how-to-learn-nix/

### nix.dev

- https://nix.dev/tutorials/dev-environment

可以关注一下:
https://nix.dev/anti-patterns/language

## 安装特定版本的程序

- https://unix.stackexchange.com/questions/529065/how-can-i-discover-and-install-a-specific-version-of-a-package
  - https://lazamar.co.uk/nix-versions/ : 使用这个网站
- [ ] https://lazamar.github.io/download-specific-package-version-with-nix/

  - 这个文摘暂时没有看懂

- 还可以

```nix
let
  old = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/7d7622909a38a46415dd146ec046fdc0f3309f44.tar.gz";
    })
    { };

  clangd13 = old.clang-tools;
in {
  home.packages = with pkgs; [
  clangd13
```

### 使用特定版本的 gcc 或者 llvm

- https://stackoverflow.com/questions/50277775/how-do-i-select-gcc-version-in-nix-shell

  - 切换 gcc 的方法:

- https://stackoverflow.com/questions/62592923/nix-how-to-change-stdenv-in-nixpkgs-mkshell
  - 参考 libbpf.nix 中的

## shell.nix 和 default.nix 的区别

- https://stackoverflow.com/questions/44088192/when-and-how-should-default-nix-shell-nix-and-release-nix-be-used

## 虚拟化

- https://github.com/Mic92/nixos-shell
  - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/qemu-vm.nix
- https://github.com/astro/microvm.nix
  - 是配置了文档的: https://astro.github.io/microvm.nix/intro.html
- https://github.com/nix-community/nixos-generators
  - nixos-generate -f iso -c /etc/nixos/configuration.nix : 利用 squashfs 直接构建出来安装用 iso
  - 可以通过 configuration.nix 直接打包出来 iso，这不就免除了每次手动安装 iso 的时候还要下载
  - 等待版本升级吧，nixos-generate --disk-size 102400 -f qcow -c /home/martins3/core/vn/docs/qemu/sh/configuration.nix 中 disk-size 不识别，不设置也会报错，看上去这会是一个可行的路线的
    - 这应该就是正确的解决办法了
- nixpacks
  - https://news.ycombinator.com/item?id=32501448

如果是完全手动安装一个，还是实在是太复杂了:
  - https://nix.dev/tutorials/nixos/nixos-configuration-on-vm.html
    - 这个好归好，但是使用的共享目录啊


## 其他有趣的 Linux Distribution

- https://kisslinux.org/install
- [guix](https://boilingsteam.com/i-love-arch-but-gnu-guix-is-my-new-distro/)

## 值得一看的资料

- https://github.com/nix-community/awesome-nix
- https://ryantm.github.io/nixpkgs/stdenv/platform-notes/ : 一个人的笔记

## [ ] flake.nix

实验特性
- https://nixos.wiki/wiki/Flakes
- https://news.ycombinator.com/item?id=36362225

## switch caps 和 escape

https://unix.stackexchange.com/questions/377600/in-nixos-how-to-remap-caps-lock-to-control

似乎需要:

```sh
gsettings reset org.gnome.desktop.input-sources xkb-options
gsettings reset org.gnome.desktop.input-sources sources
```

也许也需要执行下:
setxkbmap -option caps:swapescape

## 问题

- [ ] 直接下载的 vs debug adaptor 无法正确使用:
  - https://github.com/Martins3/My-Linux-Config/issues/14
- [ ] making a PR to nixpkgs : https://johns.codes/blog/updating-a-package-in-nixpkgs
- https://ejpcmac.net/blog/about-using-nix-in-my-development-workflow/
- https://www.ertt.ca/nix/shell-scripts/
- [ ] 挂载磁盘 https://nixos.org/manual/nixos/stable/index.html#ch-file-systems

## 需要验证的问题

- [ ] 不知道为什么，需要安装所有的 Treesitter，nvim 才可以正常工作。

## Nix/NixOs 踩坑记录

最近时不时的在 hacknews 上看到 nix 相关的讨论:

- [Nixos-unstable’s iso_minimal.x86_64-linux is 100% reproducible!](https://news.ycombinator.com/item?id=27573393)
- [Will Nix Overtake Docker?](https://news.ycombinator.com/item?id=29387137)
- https://news.ycombinator.com/item?id=34119868

Ian Henry 的[How to Learn Nix](https://ianthehenry.com/posts/how-to-learn-nix/) 写的好长啊，

## 问题

这三个命令的区别是什么:
- nix-env -i git
- nix-env -iA nixpkgs.git
- nix profile install nixpkgs#git

## 文档

### manual : https://nixos.org/manual/nix/stable/introduction.html

> This means that it treats packages like values in purely functional programming languages such as Haskell — they are built by functions that don’t have side-effects, and they never change after they have been built.
> 充满了哲学的感觉啊。

For example, the following command gets all dependencies of the Pan newsreader, as described by its Nix expression:

- https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/newsreaders/pan/default.nix

```sh
nix-shell '<nixpkgs>' -A pan
```

The main command for package management is nix-env.

Components are installed from a set of Nix expressions that tell Nix how to build those packages, including, if necessary, their dependencies. There is a collection of Nix expressions called the Nixpkgs package collection that contains packages ranging from basic development stuff such as GCC and Glibc, to end-user applications like Mozilla Firefox. (Nix is however not tied to the Nixpkgs package collection; you could write your own Nix expressions based on Nixpkgs, or completely new ones.)

> 1. Nix Expressions 实际上是在描述一个包是如何构建的
> 2. Nixpkgs 是一堆社区构建好的
> 3. 完全可以自己来构建这些内容

You can view the set of available packages in Nixpkgs:

```c
nix-env -qaP
```

The flag -q specifies a query operation, -a means that you want to show the “available” (i.e., installable) packages, as opposed to the installed packages, and -P prints the attribute paths that can be used to unambiguously select a package for installation (listed in the first column).

You can install a package using nix-env -iA. For instance,

```c
nix-env -iA nixpkgs.subversion
```

Profiles and user environments are Nix’s mechanism for implementing the ability to allow different users to have different configurations, and to do atomic upgrades and rollbacks.

#### 直接跳转到 Chapter 5

使用 https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/default.nix 作为例子。

### manual : https://nixos.org/manual/nixpkgs/stable/

- [ ] 这个是侧重什么东西啊?

### manual : https://nixos.org/manual/nixpkgs/unstable/



## 你需要认真学习一波

https://www.reddit.com/r/NixOS/comments/119sfg8/how_long_did_it_take_you_to_really_grok_nixos/

## 文摘

- [ ] https://christine.website/blog/nix-flakes-2-2022-02-27 : xe 写的
- [ ] https://roscidus.com/blog/blog/2021/03/07/qubes-lite-with-kvm-and-wayland/
  - 简单的介绍 qubes ，nixos and SpectrumOS
  - 对应的讨论: https://news.ycombinator.com/item?id=26378854
- https://matklad.github.io//2022/03/14/rpath-or-why-lld-doesnt-work-on-nixos.html ： rust 大佬解决 nix 的问题 blog

- https://github.com/NixOS/nix/issues/6210 : 有趣
- [ ] https://alexpearce.me/2021/07/managing-dotfiles-with-nix/
  - Nix 下如何管理 package 的
- https://github.com/Misterio77/nix-colors : 主题

## 资源

- https://github.com/mikeroyal/NixOS-Guide : 乱七八糟的，什么都有
- https://github.com/mitchellh/nixos-config
- https://github.com/Misterio77/nix-starter-configs : Simple and documented config templates to help you get started with NixOS + home-manager + flakes. All the boilerplate you need!

## 目前最好的教程，应该上手完成之后，就使用这个

- https://scrive.github.io/nix-workshop/01-getting-started/03-resources.html 资源合集

## 关键参考

https://github.com/xieby1/nix_config

## similar project

- https://github.com/linuxkit/linuxkit

## 一个快速的教程

https://nixery.dev/nix-1p.html

## 问题

- [ ] nix-shell 和 nix-env 各自侧重什么方向啊
- [ ] 什么是 flake 啊？
- [ ] 按照现在的配置，每次在 home-manager switch 的时候，都会出现下面的警告。

```txt
warning: not including '/nix/store/ins8q19xkjh21fhlzrxv0dwhd4wq936s-nix-shell' in the user environment because it's not a directory
```

- [ ] 下面的这两个流程是什么意思

```sh
nix-env -f ./linux.nix -i
shell-nix --cmd zsh
```

- [ ] 无法理解这是什么安装方法，可以假如到 home.nix 中吗?

```sh
nix-env -i -f https://github.com/nix-community/rnix-lsp/archive/master.tar.gz
```

之后重新安装之后，就可以出现:

```txt
Oops, Nix failed to install your new Home Manager profile!

Perhaps there is a conflict with a package that was installed using
"nix-env -i"? Try running

    nix-env -q

and if there is a conflicting package you can remove it with

    nix-env -e {package name}

Then try activating your Home Manager configuration again.
```

- [ ] 理解一下什么叫做 overriding 啊

```sh
$ nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkg-config ncurses ];})'
[nix-shell] $ unpackPhase && cd linux-*
[nix-shell] $ make menuconfig
```

- [ ] https://github.com/fannheyward/coc-pyright 描述了 python 的工作环境

## nur

https://nur.nix-community.org/

## 到底如何编译 Linux 内核

https://ryantm.github.io/nixpkgs/builders/packages/linux/

## 有趣

- WSL 上使用 home-manager : https://github.com/viperML/home-manager-wsl
- [ ] https://github.com/jetpack-io/devbox
  - 和 direnv 是啥关系？

## 桌面环境

曾经简单的尝试过如下:

- https://github.com/denisse-dev/dotfiles/blob/main/.config/i3/config
- https://github.com/leftwm/leftwm-theme
- https://github.com/manilarome/the-glorious-dotfiles/
- https://github.com/lcpz/awesome-copycats.git

但是发现其中存在很多[小问题](https://github.com/lcpz/lain/issues/503)，很多配置也是没怎么维护，所以还是使用默认的 gnome 了。

## 4k 屏幕

虽然，我没有做过图形开发，但是我估计适配 4k 屏幕是个非常复杂的问题，Linux 目前对于这个问题处理的也不是很好:

- https://news.ycombinator.com/item?id=25970690

例如

## 组件

- polybar
- rofi
- picom

## nixos 的

https://www.youtube.com/@NixCon

## 如何升级 (update / upgrade)

### 小版本更新
  - https://superuser.com/questions/1604694/how-to-update-every-package-on-nixos
    - sudo nix-channel --update
  - 在这里看下日期: https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable/


### 更新 nixos 为 24.11

内容参考这里:

- https://nixos.org/manual/nixos/stable/index.html#sec-upgrading
- https://news.ycombinator.com/item?id=33815085

修改 scripts/nix/nix-channel.sh
```sh
nixos-rebuild switch --upgrade
```

如果仅仅安装了 home-manager ，那么使用 sudo ，会遇到网络问题的。

## 垃圾清理

sudo nix-collect-garbage -d

nix-store --gc
sudo nixos-rebuild boot

遇到了相同的问题(boot 分区满了)，头疼:
https://discourse.nixos.org/t/what-to-do-with-a-full-boot-partition/2049/13

搞了半天，这应该是是一个 bug ，这个时候需要手动删除 /boot 下的一些内容才可以。

## 包搜索


## 静态编译

- 似乎安装这个是不行的: glibc.static

应该使用这种方法:
nix-shell -p gcc glibc.static

## devenv

如何使用

## 如何安装 steam

- [Installing Steam on NixOS in 50 simple steps](https://jmglov.net/blog/2022-06-20-installing-steam-on-nixos.html)

但是社区感觉实在是太复杂了，所以存在一个专门的 hacking：

```nix
nixpkgs.config.allowUnfree = true;
programs.steam.enable = true;
```

装好之后，发现也没啥用。

## nix-index 是做什么的

## 自定义字体

- 参考： https://www.adaltas.com/en/2022/03/29/nix-package-creation-install-font/
- 安装 : https://github.com/atelier-anchor/smiley-sans

但是不知道如何指定安装这个!

## 和各种 dotfile manager 的关系是什么

- https://www.chezmoi.io/

## nix M1

- https://github.com/tpwrules/nixos-m1/blob/main/docs/uefi-standalone.md

## vpn

### tailscale

- tailscale : https://tailscale.com/blog/nixos-minecraft/

tskey-auth-XXX 上网页上 generate 的:

```sh
sudo tailscale up --auth-key tskey-auth-XXX
```

### [ ] wireguard

## wasm

似乎 wasm 的配置很复杂，连最基本的配置都搞不定:

- https://rustwasm.github.io/docs/book/game-of-life/hello-world.html

这个人解决了问题，最后的评论中看到了 flake.nix，还有 flake.lock，我的鬼鬼！

- https://gist.github.com/573/885a062ca49d2db355c22004cc395066

如果彻底搞定后，可以尝试下这个:
https://github.com/casonadams/z-tab-bar

## nixops

- https://github.com/NixOS/nixops

## 记录一次断电的处理

因为小米智障插座，直接断电，导致磁盘信息不对。

- 进入 grub ，e 增加参数 `init=/bin/sh`，enter
- 输入

```c
export PATH=/nix/var/nix/profiles/system/sw/bin:/nix/var/nix/profiles/system/sw/sbin
fsck -a /dev/nvme0n1p1
fsck -a /dev/nvme0n1p2
fsck -a /dev/nvme0n1p3
```

参考: https://www.reddit.com/r/NixOS/comments/4fnsxb/how_do_i_run_fsck_manually_on_root_in_nixos/

xfs_repair -L /dev/dm-1

> -L : 最后的武器，会切掉部分日志

## [ ] 如何编译一个静态的 QEMU，测试启动速度

参考 scripts/nix/pkg/static-qemu.nix

## [ ] nixos 没有 centos 中对应的 kernel-tools 包

类似 kvm_stat 是没有现成的包，非常难受。nixmd

## nixos 上无法安装 pytype

使用 pyright 安装的时候，出现如下错误。
libstdc++.so.6

## 构建 qemu guest 镜像

- https://nixos.mayflower.consulting/blog/2018/09/11/custom-images/

虽然执行有点问题，但是值得借鉴:

```sh
#! /nix/store/96ky1zdkpq871h2dlk198fz0zvklr1dr-bash-5.1-p16/bin/bash

export PATH=/nix/store/wxb674h6dp7h63na8z6jwpagps811jl7-coreutils-9.1/bin${PATH:+:}$PATH

set -e

NIX_DISK_IMAGE=$(readlink -f "${NIX_DISK_IMAGE:-./nixos.qcow2}")

if ! test -e "$NIX_DISK_IMAGE"; then
    /nix/store/zsf59dn5sak8pbq4l3g5kqp7adyv3fph-qemu-host-cpu-only-7.1.0/bin/qemu-img create -f qcow2 "$NIX_DISK_IMAGE" \
      1024M
fi

# Create a directory for storing temporary data of the running VM.
if [ -z "$TMPDIR" ] || [ -z "$USE_TMPDIR" ]; then
    TMPDIR=$(mktemp -d nix-vm.XXXXXXXXXX --tmpdir)
fi



# Create a directory for exchanging data with the VM.
mkdir -p "$TMPDIR/xchg"



cd "$TMPDIR"




# Start QEMU.
exec /nix/store/zsf59dn5sak8pbq4l3g5kqp7adyv3fph-qemu-host-cpu-only-7.1.0/bin/qemu-kvm -cpu max \
    -name nixos \
    -m 1024 \
    -smp 1 \
    -device virtio-rng-pci \
    -net nic,netdev=user.0,model=virtio -netdev user,id=user.0,"$QEMU_NET_OPTS" \
    -virtfs local,path=/nix/store,security_model=none,mount_tag=nix-store \
    -virtfs local,path="${SHARED_DIR:-$TMPDIR/xchg}",security_model=none,mount_tag=shared \
    -virtfs local,path="$TMPDIR"/xchg,security_model=none,mount_tag=xchg \
    -drive cache=writeback,file="$NIX_DISK_IMAGE",id=drive1,if=none,index=1,werror=report -device virtio-blk-pci,drive=drive1 \
    -device virtio-keyboard \
    -usb \
    -device usb-tablet,bus=usb-bus.0 \
    -kernel ${NIXPKGS_QEMU_KERNEL_nixos:-/nix/store/k9xnkgjs5dwjzww8n9c3dsx3hl7axl5k-nixos-system-nixos-22.11.2999.a7cc81913bb/kernel} \
    -initrd /nix/store/k9xnkgjs5dwjzww8n9c3dsx3hl7axl5k-nixos-system-nixos-22.11.2999.a7cc81913bb/initrd \
    -append "$(cat /nix/store/k9xnkgjs5dwjzww8n9c3dsx3hl7axl5k-nixos-system-nixos-22.11.2999.a7cc81913bb/kernel-params) init=/nix/store/k9xnkgjs5dwjzw
w8n9c3dsx3hl7axl5k-nixos-system-nixos-22.11.2999.a7cc81913bb/init regInfo=/nix/store/byyk6x729q54ys1dv8m852v5f7g39ssn-closure-info/registration consol
e=ttyS0,115200n8 console=tty0 $QEMU_KERNEL_PARAMS" \
    $QEMU_OPTS \
    "$@"
```

- [ ] [Kernel Debugging with QEMU](https://nixos.wiki/wiki/Kernel_Debugging_with_QEMU) : 看上去这就是我们需要的，但是实际上，还是差点意思

  - https://wiki.cont.run/kernel-development-with-nix/
  - https://jade.fyi/blog/nixos-disk-images-m1/

- https://hoverbear.org/blog/nix-flake-live-media/

- [ ] https://jade.fyi/blog/nixos-disk-images-m1/

- [ ] https://mattwidmann.net/notes/running-nixos-in-a-vm/
- [ ] https://nixos.mayflower.consulting/blog/2018/09/11/custom-images/

感觉目前的时机不成熟，或者我对于这个的理解有问题。

- 因为 nixos 的 initrd 如果和 kernel 不匹配的话，应该启动不了

  - 使用 execsnoop 看启动参数吧

- 确实提供过如何制作 make-disk-image.nix 的操作，但是还是远远不够
- https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix
- https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/qemu-guest.nix

- 有很多人介绍 nixos 如何制作出来 iso 的，然后再去安装，其实也算是一个路径，但是 -kernel 问题必须解决。

总之，等我对于 nixos 理解在深入一点再来搞这个问题吧。

而且，无论如何，都是需要在 guest 中使用 crash 的。

在 guest 中使用 docker 环境？

不要把简单问题复杂化了！

使用 shell 初始化即可，遇到问题，以后再说。

而且导致无法 dracut

虽然尝试将其作为完全的测试的 Guest 是失败了，但是
使用 nixos 搭建一个和 host 机器完全相同的虚拟机，然后可以实现 host guest 环境对比

## 桌面环境

- https://wiki.hyprland.org/Nix/
- https://github.com/yaocccc/dwm : 看上去还不错，还有 bilibili 的介绍

启用 hyprland 的方法:

```diff
commit 6746b06b79275b160a433567b47d5e6c49445e77
Author: Martins3 <hubachelar@gmail.com>
Date:   Sun Jun 25 22:23:53 2023 +0800

    cool

diff --git a/nixpkgs/home/gui.nix b/nixpkgs/home/gui.nix
index 8f0d909..fac00dc 100644
--- a/nixpkgs/home/gui.nix
+++ b/nixpkgs/home/gui.nix
@@ -19,7 +19,7 @@ in
 {

   imports = [
-    ./app/gnome.nix
+    # ./app/gnome.nix
   ];

   home.packages = with pkgs; [
diff --git a/nixpkgs/sys/gui.nix b/nixpkgs/sys/gui.nix
index 61f4f3e..a525fb5 100644
--- a/nixpkgs/sys/gui.nix
+++ b/nixpkgs/sys/gui.nix
@@ -1,17 +1,17 @@
 { config, pkgs, ... }:

 {
-  services.xserver = {
-    enable = true;
-    xkbOptions = "caps:swapescape";
-    # 暂时可以使用这个维持生活吧
-    # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
-    # https://nixos.org/manual/nixos/stable/index.html#sec-gnome-gsettings-overrides
-  };
+  # services.xserver = {
+  #   enable = true;
+  #   xkbOptions = "caps:swapescape";
+  #   # 暂时可以使用这个维持生活吧
+  #   # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
+  #   # https://nixos.org/manual/nixos/stable/index.html#sec-gnome-gsettings-overrides
+  # };

-  services.xserver.displayManager.gdm.enable = true;
-  services.xserver.displayManager.gdm.wayland = false;
-  services.xserver.desktopManager.gnome.enable = true;
+  # services.xserver.displayManager.gdm.enable = true;
+  # services.xserver.displayManager.gdm.wayland = false;
+  # services.xserver.desktopManager.gnome.enable = true;

   # see xieby1
   fonts.fonts = (
diff --git a/nixpkgs/system.nix b/nixpkgs/system.nix
index 8490c95..c1c018b 100644
--- a/nixpkgs/system.nix
+++ b/nixpkgs/system.nix
@@ -20,6 +20,12 @@ in
     "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
     "https://cache.nixos.org/"
   ];
+  programs.hyprland.enable = true;
+ services.xserver.desktopManager = {
+    gnome.enable = false;
+    plasma5.enable = false;
+    xterm.enable = false;
+  };

   time.timeZone = "Asia/Shanghai";
   time.hardwareClockInLocalTime = true;
```

还是感觉收益不大，而且启动之后 edge 无法使用。再度放弃。

## 如何调试 host 内核

参考 nixpkgs/pkgs/os-specific/linux/kernel/linux-6.2.nix ，我发现其

- [ ] nixpkgs/pkgs/top-level/linux-kernels.nix 中应该会告诉是否打了 patch 以及函数的情况
  - [ ] 使用 /proc/config.gz 维持下生活吧
  - sudo insmod arch/x86/kvm/kvm-intel.ko # 似乎不行
  - 修改一个字母，所有内容全部重新编译，这不科学啊！

## cargo install 几乎没有成功过

cargo install rusty-krab-manager

## virt-manager 可以尝试一下

https://nixos.wiki/wiki/Virt-manager

```txt
virtualisation.libvirtd.enable = true;
programs.dconf.enable = true;
environment.systemPackages = with pkgs; [ virt-manager ];
```

## [NixOS 常见问题解答](https://github.com/nixos-cn/NixOS-FAQ)

nixos 中文社区下的项目 https://github.com/nixos-cn/flakes :

## 如何编译一个静态的 bear 出来

- 问题 1
  - 将三个库放到 with pkgs.pkgsStatic 中，但是发现 grpc 都无法正确使用
- 问题 2
  - bear 本身对于 static 的支持不够好，居然还存在 preload 的方法，应该在
    source/CMakeLists.txt 将 set(SUPPORT_PRELOAD 1) 去掉，可以辅助速度
- 问题 3
  - 打上上一个的补丁， with pkgs.buildPackages; 中使用 glibc.static 会编译失败，但是去掉之后，会最后和 glibc 链接
  - 使用 glibc.static 中是可以编译出来静态环境 a.out 的，所以我更加怀疑是 bear 项目本身的原因

尝试到此结束，不如去分析一下 signal_pending 的问题

## 输入法

https://github.com/NixOS/nixpkgs/issues/53085

## coredump

- 存储在 /var/lib/systemd/coredump
- 解压方法: zstd -d core.qemu.zst
- 分析方法: gdb path/to/the/binary path/to/the/core/dump/file

nixos 的处理方式:

```txt
🧀  cat /proc/sys/kernel/core_pattern
|/nix/store/34am2kh69ll6q03731imxf21jdbizda2-systemd-251.15/lib/systemd/systemd-coredump %P %u %g %s %t %c %h
```

ubuntu 的处理方式:

```txt
var/lib/systemd/coredump$  cat /proc/sys/kernel/core_pattern
|/usr/share/apport/apport -p%p -s%s -c%c -d%d -P%P -u%u -g%g -- %E
```

通过检查 /var/log/apport.log 可以知道

```txt
ERROR: apport (pid 17768) Thu Apr 27 03:08:58 2023: called for pid 17767, signal 11, core limit 0, dump mode 1
ERROR: apport (pid 17768) Thu Apr 27 03:08:58 2023: executable: /a.out (command line "./a.out")
ERROR: apport (pid 17768) Thu Apr 27 03:08:58 2023: executable does not belong to a package, ignoring
```

所以需要调整一下:

```sh
ulimit -c unlimited
```

其路径也是在 /var/lib/apport/coredump 中。

## [ ] infer 处理下

https://fbinfer.com/docs/getting-started/

## 虚拟机中安装

- gui.nix 不会被 include 进去

## 有些需要手动设置的内容

gnome 有些内容需要手动设置

1. 将 edge 设置为默认的浏览器, gnome setting
2. ctrl 1 进入到第一个 workspace
3. Vn 和 My-Linux-Config 两个仓库中

```sh
npm install -g @lint-md/cli@beta
pre-commit install
```

但是 pre-commit 不知道为什么，并没有起效。 4. escape and capslock 的切换

```sh
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
```

参考: https://nixos.org/manual/nixos/stable/index.html#sec-gnome-gsettings-overrides

不知道为什么 efm 在新装的环境中无法使用了。

## [ ] 到底如何切换 escape 和 caps

这种方法是通过 gnome 实现的:

```nix
  services.xserver = {
    enable = true;
    xkbOptions = "caps:swapescape"; # 之前还可以靠这个维持生活的
  };
```

可以参考这个
https://www.reddit.com/r/vim/comments/1442ads/mapping_capslock_to_esc_is_life_changing/

## dual boot 双系统

https://nixos.wiki/wiki/Bootloader

在 13900K 上可以采用这个系统，但是笔记本上似乎有问题，而且 grub 本身有时候会出现问题。

```nix
  /* /dev/nvme1n2p3: BLOCK_SIZE="512" UUID="0470864A70864302" TYPE="ntfs" PARTUUID="8402854e-03" */
  /* /dev/nvme1n2p1: LABEL="M-gM-3M-;M-gM-;M-^_M-dM-?M-^]M-gM-^UM-^Y" BLOCK_SIZE="512" UUID="409E41739E416310" TYPE="ntfs" PARTUUID="8402854e-01" */
  /* /dev/nvme1n2p2: BLOCK_SIZE="512" UUID="02084242084234C7" TYPE="ntfs" PARTUUID="8402854e-02" */
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # https://www.reddit.com/r/NixOS/comments/wjskae/how_can_i_change_grub_theme_from_the/
      # theme = pkgs.nixos-grub2-theme;
      theme =
        pkgs.fetchFromGitHub {
          owner = "shvchk";
          repo = "fallout-grub-theme";
          rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
          sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
        };
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;

      # useOSProber = true; # 没有说的那么不堪，还是很好用的

      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      # /dev/nvme1n1p1: BLOCK_SIZE="512" UUID="3A22AF3A22AEF9D1" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="1b23d1fb-c1ad-4b8b-83e1-79005771a027"
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          search --fs-uuid --set=root 4957-45A0
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };
```

## manifest.nix 被损坏

- https://github.com/NixOS/nixpkgs/issues/18279

使用

```nix
nix-env --rollback
```

然后，

```nix
home-manager switch
```

## lsof 存在警告

```txt
[sudo] password for martins3:
lsof: WARNING: can't stat() fuse.gvfsd-fuse file system /run/user/1000/gvfs
      Output information may be incomplete.
lsof: WARNING: can't stat() fuse.portal file system /run/user/1000/doc
      Output information may be incomplete.
COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF     NODE NAME
zsh     34262 martins3  cwd    DIR  259,2     4096 39060352 bus
sleep   34801 martins3  cwd    DIR  259,2     4096 39060352 bus
```

## sway : i3-compatible Wayland compositor

- https://nixos.wiki/wiki/Sway
- https://github.com/pkivolowitz/asm_book#table-of-contents

如何在 nixos 中启用 wayland
https://drakerossman.com/blog/wayland-on-nixos-confusion-conquest-triumph

## notification

不知道为什么大家会专门的 notification 工具来
https://github.com/emersion/mako

如果想要简单的 hacking 一下:
https://wiki.archlinux.org/title/Desktop_notifications

如果更多的定制化:
[dunst](https://github.com/dunst-project/dunst)
man home-configuration.nix 中搜索 dunst

## canTouchEfiVariables 到底是什么来头

https://nixos.wiki/wiki/Bootloader 中最后提到如何增加 efi

```sh
efibootmgr -c -d /dev/nvme0n1 -p 1 -L NixOS-boot -l '\EFI\NixOS-boot\grubx64.efi'
```

1. 注意，-p 1 来设置那个 partition 的。
2. 后面的那个路径需要将 boot 分区 mount 然后具体产看，还有一次是设置的 "\EFI\nixo\BOOTX64.efi"

这个说的是什么意思来着:

```nix
efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
```

我设置的是 /boot 似乎影响也不大啊!

不知道为什么 efibootmgr 在 home.cli 中无法安装。

删除一个:

```txt
sudo efibootmgr  -B -b 3 # 3 是参数
```

设置优先级
sudo efibootmgr -o 0,1,2


## flakes book

- https://github.com/ryan4yin/nixos-and-flakes-book

作者的配置:
- https://github.com/ryan4yin/nix-config

感觉写的相当不错。但是，问题是，我老版本的 nix channel 之类的还没掌握，怎么现在又切换了啊!

## nixos distribution

- https://github.com/exploitoverload/PwNixOS
  - 也可以作为参考

## 如何代理

```txt
sudo proxychains4 -f /home/martins3/.dotfiles/config/proxychain.conf  nixos-rebuild switch
```


## 不知道如何调试代码，debug symbol 如何加载

- https://nixos.wiki/wiki/Debug_Symbols

## [x] sar 无法正常使用

```txt
🧀  sar
Cannot open /var/log/sa/sa21: No such file or directory
Please check if data collecting is enabled
```

兄弟，是这个:

```sh
sar -n DEV 1
```

## 如何在 cgroup 中编译内核

可以采用这种方法:

```sh
sudo cgexec -g memory:mem3 nix-shell --command "make -j32"
```

但是这种方法就不太妙了:

```sh
sudo cgexec -g memory:mem3 make -j32
```

## 文摘

- [my first expression of nix](https://news.ycombinator.com/item?id=36387874_)
  - https://mtlynch.io/notes/nix-first-impressions/
    https://news.ycombinator.com/item?id=36387874
    https://news.ycombinator.com/item?id=32922901

## 搞搞 cuda 吧

https://nixos.org/community/teams/cuda

```nix
# Run with `nix-shell cuda-shell.nix`
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
   name = "cuda-env-shell";
   buildInputs = with pkgs; [
     git gitRepo gnupg autoconf curl
     procps gnumake util-linux m4 gperf unzip
     cudatoolkit linuxPackages.nvidia_x11
     libGLU libGL
     xorg.libXi xorg.libXmu freeglut
     xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
     ncurses5 stdenv.cc binutils
   ];
   shellHook = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
      export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
      export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
      export EXTRA_CCFLAGS="-I/usr/include"
   '';
}
```

然后配合这个 : https://github.com/Tony-Tan/CUDA_Freshman

https://news.ycombinator.com/item?id=37818570

## 微信

```nix
  wrapWine_nix = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xieby1/nix_config/d57b5c4b1532eb5599b23c13ed063b2fa81edfa7/usr/gui/wrapWine.nix";
    hash = "sha256-4vdks0N46J/n8r3wdChXcJbBHPrbTexEN+yMi7zAbKs=";
  };
  weixin_nix = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xieby1/nix_config/d57b5c4b1532eb5599b23c13ed063b2fa81edfa7/usr/gui/weixin.nix";
    hash = "sha256-ql6BE/IZBM31W/yqCayAdktcV2QZ/maVzwskybFZwz0=";
  };
  weixin = import weixin_nix {
    wrapWine = import wrapWine_nix { inherit pkgs; };
  };
```

## 又一个教程

- https://gitlab.com/engmark/nix-start
- https://github.com/Misterio77/nix-starter-configs

## 构建内核的确方便，但是构建过程不能利用 cacahe ，现在修改一个 patch 就要重新构建整个内核，很烦

此外，现在 systemd 中构建一次之后，在 zsh 中还是需要重新 make 一次

## 如何在 nixpkgs 的基础上稍作修改制作自己的包

git clone nixpkgs

跑到对应的路径下去:

nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'

https://elatov.github.io/2022/01/building-a-nix-package/

## 这个库

https://github.com/svanderburg/node2nix

https://github.com/nix-community/NixOS-WSL

## 生成密码

mkpasswd -m sha-512 abc

## 构建 github action

```txt
  services.github-runners = {
    testrunner = {
      enable = true;
      user = "martins3";
      name = "test-runner";
      # token file is somewhere on local machine - in my case, it's not currently managed by nix
      tokenFile = "/home/martins3/.github-runners";
      url = "https://github.com/Martins3/R9000P";
    };
  };
```

tokenFile 只是需要包含 github 指导步骤中的 token 即可

```txt
./config.sh --url https://github.com/Martins3/R9000P --token xxx
```

## 需要将 username 变为可以定制化才可以，或者说

可以存在多个 username ，将 martins3 只是作为临时安装的一个名称，之后可以重新指向一个名称

有办法修改为 xueshi.hu 吗?

## 常见命令

```sh
nix-env -qaPA nixos.nodePackages
```

## TODO : 真正的代办

参考这个文档，重新理解下到底如何优雅的构建内核驱动来着:
https://nixos.org/manual/nixos/stable/#sec-kernel-config

> 如何编译 kernel module

- 参考这个操作: https://github.com/fghibellini/nixos-kernel-module
- 然后阅读一下: https://blog.prag.dev/building-kernel-modules-on-nixos

没必要那么复杂，参考这个，中的 : Developing out-of-tree kernel modules

- https://nixos.wiki/wiki/Linux_kernel

```sh
nix-shell '<nixpkgs>' -A linuxPackages_latest.kernel.dev
make -C $(nix-build -E '(import <nixpkgs> {}).linuxPackages_latest.kernel.dev' --no-out-link)/lib/modules/*/build M=$(pwd) modules

make SYSSRC=$(nix-build -E '(import <nixpkgs> {}).linuxPackages_latest.kernel.dev' --no-out-link)/lib/modules/$(uname -r)/source
```

- [ ] 搞清楚 kbuild 也许会让问题容易很多吧
- [ ] 似乎现在是没有办法手动编译的

> 学习 nix 语言

```sh
nix eval -f begin.nix
```

主要参考语言:

- https://nixos.wiki/wiki/Overview_of_the_Nix_Language

从 nixos virtualisation 中的实现直接 中开始入手吧

## 感受
- arm 上安装 nixos 是很容易的，不要被 https://nixos.wiki/wiki/NixOS_on_ARM 骗了
- nixos ui 主题
  - https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/icons/whitesur-icon-theme/default.nix

## 学习资料

- [ ] https://nixos.org/learn.html#learn-guides
- [ ] https://nixos.org/ 包含了一堆 examples
- [ ] https://github.com/digitalocean/nginxconfig.io : Nginx 到底是做啥的

## 工具
- noogλe : nix function exploring
  - https://github.com/nix-community/noogle
  - https://noogle.dev/
- https://mynixos.com/
  - 一个分享 nix 和 nixos 配置的网站
  - https://news.ycombinator.com/item?id=33762743


## 缺陷
- amduperf 没有
  - https://aur.archlinux.org/packages/amduprof
  - 但是 windows deb 和 rpm 都有

## 材料
nixos 在 sudo su 的情况下，基本没有什么命令可以执行，但是 nixos 之类的程序并不会如此

## 其他人的配置
- https://github.com/gvolpe/nix-config : 这个也非常不错

## bpftool 和 bpftools 居然完全是同一个程序
nixpkgs/home/cli.nix

切换之后，居然是相同的，但是在 nixpkgs 无法搜索到 bpftool
```txt
lrwxrwxrwx     - root  1 1月   1970  /home/martins3/.nix-profile/bin/bpftool -> /nix/store/md6qg2q7309xggbrjywcm5mjsiwiliv3-bpftools-6.5/bin/bpftool

lrwxrwxrwx     - root  1 1月   1970  /home/martins3/.nix-profile/bin/bpftool -> /nix/store/md6qg2q7309xggbrjywcm5mjsiwiliv3-bpftools-6.5/bin/bpftool
```


## ps 都是从那里来的

```txt
🧀  l /home/martins3/.nix-profile/bin/ps

Permissions Size User Date Modified Name
lrwxrwxrwx     - root  1 1月   1970  /home/martins3/.nix-profile/bin/ps -> /nix/store/gb18gj7zpbhdavmsdr5090rx7lsvxvyk-procps-3.3.17/bin/ps
```

```txt
🧀  l /run/current-system/sw/bin/ps

Permissions Size User Date Modified Name
lrwxrwxrwx     - root  1 1月   1970  /run/current-system/sw/bin/ps -> /nix/store/gb18gj7zpbhdavmsdr5090rx7lsvxvyk-procps-3.3.17/bin/ps
```
结论: 系统中本来就是自带了一份

## wps 的版本还是停留在 2019
https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/office/wpsoffice/default.nix

但是不知道怎么给他们更新。

## 基于 nix ?
https://github.com/flox/flox

## 参考这个资源
https://dotfiles.github.io/

## 太坑了
- https://github.com/NixOS/nixpkgs/issues/18995

在 clang 自动携带了 flags :


## linux defualt.nix

之前的写法
```nix
{ pkgs ? import <nixpkgs> { },
  unstable ? import <nixos-unstable> { }
}:

pkgs.stdenv.mkDerivation {
  name = "yyds";
  buildInputs = with pkgs; [
  # ....
  ];
}
```

还有一种写法:
```nix
with import <nixpkgs> {};
pkgs.llvmPackages.stdenv.mkDerivation {
  hardeningDisable = [ "all" ];
  name = "yyds";
  buildInputs = with pkgs; [

    getopt
    flex
    ];
}
```

还有一种写法:
```nix

with import <nixpkgs> {};

pkgs.llvmPackages_14.stdenv.mkDerivation {
   hardeningDisable = [ "all" ];
  name = "yyds";
  buildInputs = with pkgs; [

  ];
  }

```

也可以参考: https://nixos.wiki/wiki/Using_Clang_instead_of_GCC


## 使用 clang 交叉编译内核

https://stackoverflow.com/questions/61771494/how-do-i-cross-compile-llvm-clang-for-aarch64-on-x64-host

```txt
🧀  clang -arch arm64 aio.c -o main_arm64
clang-16: warning: argument unused during compilation: '-arch arm64' [-Wunused-command-line-argument]
```
检查内核 compile_commands.json ，果然是没有输出的。

## 搭建下 nixos 上 hack kvm 的方法
- https://phip1611.de/blog/building-an-out-of-tree-linux-kernel-module-in-nix/

文档还是很简单的，但是这个代码仓库就太复杂了。

## 备份一些代码
```nix
  systemd.user.services.kernel = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      # User = "martins3";
      Type = "forking";
      # RemainAfterExit = true;
      ExecStart = "/home/martins3/.nix-profile/bin/tmux new-session -d -s kernel '/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/sync-kernel.sh'";
      Restart = "no";
    };
  };

  # systemctl --user list-timers --all
  systemd.user.timers.kernel = {
    enable = true;
    # timerConfig = { OnCalendar = "*-*-* 4:00:00"; };
    timerConfig = { OnCalendar = "Fri *-*-* 4:00:00"; }; #  周五早上四点运行一次
    wantedBy = [ "timers.target" ];
  };

  systemd.user.timers.drink_water = {
    enable = true;
    timerConfig = { OnCalendar="*:0/5"; };
    wantedBy = [ "timers.target" ];
  };

  systemd.user.services.drink_water = {
    enable = false;
    unitConfig = { };
    serviceConfig = {
      Type = "forking";
      ExecStart = "/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/drink_water.sh";
      Restart = "no";
    };
  };

  systemd.user.services.monitor = {
    enable = false;
    unitConfig = { };
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/monitor.sh";
      Restart = "no";
    };
    wantedBy = [ "timers.target" ];
  };
```

## 如何解决掉本身就在代理的问题
- https://github.com/NixOS/nixpkgs/issues/27535 是我操作有问题，不行啊！

## 社区危机
- https://save-nix-together.org/
- https://discourse.nixos.org/t/nixos-foundation-board-giving-power-to-the-community/44552?filter=summary
- https://dataswamp.org/~solene/2024-04-27-nix-internal-crisis.html
- https://www.reddit.com/r/NixOS/comments/1dqn9os/4_out_of_5_nixos_board_members_have_quit/
  - 还是要凉凉吗?


## 使用 lcov 需要首先配置如下内容
```txt
nix-shell -p libgcc
```

## nixos 的 kernel 有方便的方法裁剪吗？

## 这个似乎还不错
https://github.com/gvolpe/nix-config

## 其他的 immutable 系统
https://news.ycombinator.com/item?id=40817199

Aeon 非常奇怪，安装不可以用 cdrom ，而且必须是 UEFI

## nixos 下 bcc 不可以正常使用

https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/by-name/bc/bcc/package.nix

需要我更加深入的理解才可以:

在 bcc 的构建的 nix 中，的确有:
```txt
  export PYTHONPATH=$out/${python3.sitePackages}:$PYTHONPATH
```

这个也是 https://github.com/iovisor/bcc/blob/master/FAQ.txt 中提到的:

```txt
Q: hello_world.py fails with:
   ImportError: No module named bcc
A: checkout "sudo make install" output to find out bpf package installation site,
   add it to the PYTHONPATH env variable before running the program.
   export PYTHONPATH=$(dirname `find /usr/lib -name bcc`):$PYTHONPATH
```

似乎是不可以的，进入到 bcc 中，其中连 bcc 的工具都没有，很惨:

```sh
cd $(nix-build -E "(import <nixpkgs> {}).bcc" --no-out-link)
```

### 2025-03-16 bcc 工具也不可以使用了
```txt
🧀  sudo wqlat
<built-in>:1:10: fatal error: './include/linux/kconfig.h' file not found
    1 | #include "./include/linux/kconfig.h"
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.
Traceback (most recent call last):
  File "/nix/store/ksnxa0g1lgjvgwqd9hn2f97ndr1bppbw-bcc-0.31.0/share/bcc/tools/.wqlat-wrapped", line 162, in <module>
    b = BPF(text=bpf_text)
        ^^^^^^^^^^^^^^^^^^
  File "/nix/store/ksnxa0g1lgjvgwqd9hn2f97ndr1bppbw-bcc-0.31.0/lib/python3.12/site-packages/bcc-0.31.0-py3.12.egg/bcc/__init__.py", line 480, in __init__
Exception: Failed to compile BPF module <text>
```

## 编译 bpf 的时候有警告

linux/tools/bpf/runqslower 下

如果是: make LLVM=1
```txt
clang: warning: -lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]
clang: warning: -lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]
clang: warning: -lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]
clangclang: : warning: warning: -lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]-lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]

clang: warning: -lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]
clang: warning: -lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]
clang: warning: -lLLVM-17: 'linker' input unused [-Wunused-command-line-argument]
  LINK    /home/martins3/data/linux/tools/bpf/runqslower/.output/bpftool/bootstrap/bpftool
  GEN     /home/martins3/data/linux/tools/bpf/runqslower/.output//vmlinux.h
  GEN     /home/martins3/data/linux/tools/bpf/runqslower/.output//runqslower.bpf.o
clang: warning: argument unused during compilation: '--gcc-toolchain=/nix/store/llmjvk4i2yncv8xqdvs4382wr3kgdmvp-gcc-13.2.0' [-Wunused-command-line-argument]
  GEN     /home/martins3/data/linux/tools/bpf/runqslower/.output//runqslower.skel.h
  CC      /home/martins3/data/linux/tools/bpf/runqslower/.output//runqslower.o
  LINK    /home/martins3/data/linux/tools/bpf/runqslower/.output//runqslower
```
如果是: make
```txt
clang: warning: argument unused during compilation: '--gcc-toolchain=/nix/store/llmjvk4i2yncv8xqdvs4382wr3kgdmvp-gcc-13.2.0' [-Wunused-command-line-argument]
  GEN     /home/martins3/data/linux/tools/bpf/runqslower/.output//runqslower.skel.h
  CC      /home/martins3/data/linux/tools/bpf/runqslower/.output//runqslower.o
  LINK    /home/martins3/data/linux/tools/bpf/runqslower/.output//runqslower
```

## 看看这个吧
https://rasmuskirk.com/articles/2024-07-24_dont-use-nixos/

## nixos 的动态库
构建项目如果发现没有动态库，基本的解决思路是:

参考 https://discourse.nixos.org/t/where-can-i-get-libgthread-2-0-so-0/16937/6

使用 nix-index 也许可以定位是那个包提供的，在 nix 中添加:

例如，这个提供了 stdc++ ，libGL 和 glib2 的动态库的位置:
```nix
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.libGL}/lib:${pkgs.glib.out}/lib";
```

## cppman 是一个 python 库，但是没有办法安装
https://github.com/aitjcize/cppman

## 如何自动 login 似乎在图形界面上才可以配置

在 settings 中搜 login ，有一个 autoLogin 的选项。

https://help.gnome.org/admin/system-admin-guide/stable/login-automatic.html.en

配置之后接入如下:
```txt
🧀  cat /etc/gdm/custom.conf
[daemon]
AutomaticLogin=martins3
AutomaticLoginEnable=true
WaylandEnable=false
```

但是使用 nixos 的配置:

```txt
  services.displayMnager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "martins3";
  services.xserver.displayManager.gdm.autoLogin.delay = 1;
```
会有很多诡异的想象。

## ocaml

```txt
🧀  opam install herdtools7
[NOTE] External dependency handling not supported for OS family 'nixos'.
       You can disable this check using 'opam option --global depext=false'
The following actions will be performed:
  ∗ install conf-which      1        [required by herdtools7]
  ∗ install conf-gmp        4        [required by zarith]
  ∗ install conf-pkg-config 3        [required by zarith]
  ∗ install dune            3.16.0   [required by herdtools7]
  ∗ install ocamlfind       1.9.6    [required by zarith]
  ∗ install menhirSdk       20240715 [required by menhir]
  ∗ install menhirLib       20240715 [required by menhir]
  ∗ install menhirCST       20240715 [required by menhir]
  ∗ install zarith          1.14     [required by herdtools7]
  ∗ install menhir          20240715 [required by herdtools7]
  ∗ install herdtools7      7.57
===== ∗ 11 =====
Do you want to continue? [Y/n] Y

<><> Processing actions <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
Processing  5/33: [conf-gmp.4/test.c: dl] [dune.3.16.0: dl] [herdtools7.7.57: dl]
[ERROR] The compilation of conf-pkg-config.3 failed at "pkg-config --help".
∗ installed conf-which.1
⬇ retrieved conf-gmp.4  (https://opam.ocaml.org/cache)
[ERROR] The compilation of conf-gmp.4 failed at "sh -exc cc -c $CFLAGS -I/usr/local/include test.c".
⬇ retrieved herdtools7.7.57  (https://opam.ocaml.org/cache)
⬇ retrieved dune.3.16.0  (https://opam.ocaml.org/cache)
⬇ retrieved menhir.20240715  (https://opam.ocaml.org/cache)
⬇ retrieved menhirSdk.20240715  (cached)
⬇ retrieved menhirCST.20240715  (https://opam.ocaml.org/cache)
⬇ retrieved ocamlfind.1.9.6  (https://opam.ocaml.org/cache)
⬇ retrieved zarith.1.14  (https://opam.ocaml.org/cache)
∗ installed ocamlfind.1.9.6
⬇ retrieved menhirLib.20240715  (https://opam.ocaml.org/cache)
∗ installed dune.3.16.0
∗ installed menhirCST.20240715
∗ installed menhirSdk.20240715
∗ installed menhirLib.20240715
∗ installed menhir.20240715

#=== ERROR while compiling conf-pkg-config.3 ==================================#
# context     2.1.5 | linux/x86_64 | ocaml.5.2.0 | https://opam.ocaml.org#f302b6aaf01995b706f9b5a0a8fc2e6bb299
eae8
# path        ~/.opam/default/.opam-switch/build/conf-pkg-config.3
# command     ~/.opam/opam-init/hooks/sandbox.sh build pkg-config --help
# exit-code   10
# env-file    ~/.opam/log/conf-pkg-config-1134447-8c5011.env
# output-file ~/.opam/log/conf-pkg-config-1134447-8c5011.out
### output ###
# [ERROR] Command not found: pkg-config


#=== ERROR while compiling conf-gmp.4 =========================================#
# context     2.1.5 | linux/x86_64 | ocaml.5.2.0 | https://opam.ocaml.org#f302b6aaf01995b706f9b5a0a8fc2e6bb299
eae8
# path        ~/.opam/default/.opam-switch/build/conf-gmp.4
# command     ~/.opam/opam-init/hooks/sandbox.sh build sh -exc cc -c $CFLAGS -I/usr/local/include test.c
# exit-code   1
# env-file    ~/.opam/log/conf-gmp-1134447-2aea49.env
# output-file ~/.opam/log/conf-gmp-1134447-2aea49.out
### output ###
# + cc -c -I/usr/local/include test.c
# test.c:1:10: fatal error: gmp.h: No such file or directory
#     1 | #include <gmp.h>
#       |          ^~~~~~~
# compilation terminated.



<><> Error report <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
┌─ The following actions failed
│ λ build conf-gmp        4
│ λ build conf-pkg-config 3
└─
┌─ The following changes have been performed (the rest was aborted)
│ ∗ install conf-which 1
│ ∗ install dune       3.16.0
│ ∗ install menhir     20240715
│ ∗ install menhirCST  20240715
│ ∗ install menhirLib  20240715
│ ∗ install menhirSdk  20240715
│ ∗ install ocamlfind  1.9.6
└─

The former state can be restored with:
    /nix/store/sgxvws7lxhhz60j0l3grnkv6wa7fyx8v-opam-2.1.5/bin/.opam-wrapped switch import
"/home/martins3/.opam/default/.opam-switch/backup/state-20241004072102.export"
```

但是，如果这个时候 nix-shell -p gmp pkg-config ，那么还是可以正确的使用的。

看来的确是可以的

## 指定动态库

参考 scripts/nix/env/uboot.nix

## [ ] 有没有办法，只有 cache 我需要的内容
https://discourse.nixos.org/t/introducing-attic-a-self-hostable-nix-binary-cache-server/24343

似乎只有自己去 push 就可以了

## 如何快速拷贝，也许可以尝试一下，但是不容易
nix-store export 和 import

nix-copy-closure

## 如果可以构建一个 local cache ，那么就完美了
- https://zero-to-nix.com/
- https://github.com/DeterminateSystems

## 事到如今，批评还是很多的
https://www.reddit.com/r/NixOS/comments/1gfx95g/leaving_nix_dont_expect_anyone_to_care_but_you/

## [ ] home-manager 按照到 fedora 中，为什么最后还是有 vmlinux ，而且是 300 多 M

哪里配置的有问题吗?
```txt
🧀  l
Permissions Size User     Date Modified Name
dr-xr-xr-x     - martins3  1 Jan  1970   bin
dr-xr-xr-x     - martins3  1 Jan  1970   etc
lrwxrwxrwx     - martins3  1 Jan  1970   include -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/include
dr-xr-xr-x     - martins3  1 Jan  1970   lib
dr-xr-xr-x     - martins3  1 Jan  1970   libexec
lrwxrwxrwx     - martins3  1 Jan  1970   manifest.nix -> /nix/store/3i0bzw19pdx2nyrccbfqy2fz5c0sq1wa-env-manifest.nix
lrwxrwxrwx     - martins3  1 Jan  1970   rplugin.vim -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/rplugin.vim
lrwxrwxrwx     - martins3  1 Jan  1970   run -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/run
lrwxrwxrwx     - martins3  1 Jan  1970   sbin -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/sbin
dr-xr-xr-x     - martins3  1 Jan  1970   share
lrwxrwxrwx     - martins3  1 Jan  1970   usr -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/usr
lrwxrwxrwx     - martins3  1 Jan  1970   var -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/var
lrwxrwxrwx     - martins3  1 Jan  1970   vmlinux -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/vmlinux
lrwxrwxrwx     - martins3  1 Jan  1970   x86_64-unknown-linux-gnu -> /nix/store/di2a4smdj8li54di42chyfr261chw4rz-home-manager-path/x86_64-unknown-linux-gnu
nix/profiles/profile🔒 🌳
🧀  pwd
/home/martins3/.local/state/nix/profiles/profile
```
应该是和这个有关系: linuxPackages_6_10.kernel.dev


## rust
使用 https://github.com/hyperlight-dev/hyperlight 的时候，发现了一个问题

执行 just rg
```txt
error[E0463]: can't find crate for `core`
  |
  = note: the `x86_64-unknown-none` target may not be installed
  = help: consider downloading the target with `rustup target add x86_64-unknown-none`

For more information about this error, try `rustc --explain E0463`.
error: could not compile `log` (lib) due to 1 previous error
warning: build failed, waiting for other jobs to finish...
error: could not compile `scopeguard` (lib) due to 1 previous error
error: could not compile `bitflags` (lib) due to 1 previous error
error: could not compile `itoa` (lib) due to 1 previous error
error: could not compile `ryu` (lib) due to 1 previous error
error: could not compile `memchr` (lib) due to 1 previous error
error: could not compile `anyhow` (lib) due to 1 previous error
error: could not compile `serde` (lib) due to 1 previous error
error: Recipe `build-rust-guests` failed on line 38 with exit code 101

```

```txt
🤒  rustup target add x86_64-unknown-none
info: syncing channel updates for '1.81.0-x86_64-unknown-linux-gnu'
info: latest update on 2024-09-05, rust version 1.81.0 (eeb90cda1 2024-09-04)
info: downloading component 'cargo'
  8.3 MiB /   8.3 MiB (100 %)   5.4 MiB/s in  2s ETA:  0s
info: downloading component 'clippy'
info: downloading component 'rust-docs'
 15.9 MiB /  15.9 MiB (100 %)   5.2 MiB/s in  4s ETA:  0s
info: downloading component 'rust-std'
 26.8 MiB /  26.8 MiB (100 %)   4.6 MiB/s in  7s ETA:  0s
info: downloading component 'rustc'
 66.9 MiB /  66.9 MiB (100 %)   3.6 MiB/s in 20s ETA:  0s
info: downloading component 'rustfmt'
info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'rust-docs'
info: installing component 'rust-std'
 26.8 MiB /  26.8 MiB (100 %)  24.9 MiB/s in  1s ETA:  0s
info: installing component 'rustc'
 66.9 MiB /  66.9 MiB (100 %)  26.9 MiB/s in  2s ETA:  0s
info: installing component 'rustfmt'
info: downloading component 'rust-std' for 'x86_64-unknown-none'
 11.3 MiB /  11.3 MiB (100 %)   4.8 MiB/s in  3s ETA:  0s
info: installing component 'rust-std' for 'x86_64-unknown-none'
```

或者说，rust 中的如下命令如何 nix 化
```txt
rustup target add x86_64-unknown-none
rustup target add x86_64-pc-windows-msvc
```
## cache
https://github.com/nix-community/harmonia

## 仔细看看这个
https://github.com/NixOS-CN

## home manager 可以管理 systemd 吗?

https://news.ycombinator.com/item?id=42666851


## kernel 配置在这里的
kernel-modules/lib/modules/6.12.7/modules.devname

## uv 来解决 python3 的环境问题可以吗?
https://github.com/astral-sh/uv

## 原来 rust-analyzer 是一个软连接啊
```txt
🧀  l /nix/store/dyn2kdxcnhcjz13nqpdrpcgd3qj7996b-rustup-1.27.1/bin/rust-analyzer
Permissions Size User Date Modified Name
lrwxrwxrwx     - root  1 Jan  1970   /nix/store/dyn2kdxcnhcjz13nqpdrpcgd3qj7996b-rustup-1.27.1/bin/rust-analyzer -> rustup
```

这样可以解决:
```txt
rustup component add rust-analyzer
```

## 这个功能对于我来说，很重要
安装的时候可以不用联网。
https://github.com/tfc/nixos-auto-installer

## nixos 的 kernel 为什么默认打开了
```txt
CONFIG_KFENCE=y
```
看看这个导致了多少的性能损失 和 内存损失。

## 系统中的 contained 是从哪里来的

```txt
        ├─containerd-shim─┬─redis-server───4*[{redis-server}]
        │                 └─12*[{containerd-shim}]
```

## coreutils 中的 .envrc 可以关注下

https://github.com/uutils/coreutils/blob/main/.envrc


## 研究下动态库吧，每次都要卡好久的时间
https://github.com/nix-community/nix-ld

似乎 pkg-config 就可以帮我们把动态库都找到，也就不需要额外的 config 了。
