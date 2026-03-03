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
nix-prefetch-url https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit
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

## syncthing

强烈推荐，相当于一个自动触发的 rsync ，配置也很容易:

- https://wes.today/nixos-syncthing/
- https://nixos.wiki/wiki/Syncthing

使用注意项，可以在两个机器中编辑同一个文件夹中的文件，
但是注意不要同时多个机器上编辑同一个文件，否则存在冲突。

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

## cargo install 几乎没有成功过

cargo install rusty-krab-manager

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

## [ ] infer 处理下

https://fbinfer.com/docs/getting-started/

## 有些需要手动设置的内容

gnome 有些内容需要手动设置

1. 将 edge 设置为默认的浏览器, gnome setting
2. ctrl 1 进入到第一个 workspace
3. Vn 和 My-Linux-Config 两个仓库中

```sh
npm install -g @lint-md/cli@beta
pre-commit install
```

但是 pre-commit 不知道为什么，并没有起效。 
4. escape and capslock 的切换

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

## 如何在 cgroup 中编译内核

可以采用这种方法:

```sh
sudo cgexec -g memory:mem3 nix-shell --command "make -j32"
```

但是这种方法就不太妙了:

```sh
sudo cgexec -g memory:mem3 make -j32
```

## 教程

- [my first expression of nix](https://news.ycombinator.com/item?id=36387874_)
  - https://mtlynch.io/notes/nix-first-impressions/
    https://news.ycombinator.com/item?id=36387874
    https://news.ycombinator.com/item?id=32922901
- https://gitlab.com/engmark/nix-start
- https://github.com/Misterio77/nix-starter-configs


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

## 需要将 username 变为可以定制化才可以，或者说

可以存在多个 username ，将 martins3 只是作为临时安装的一个名称，之后可以重新指向一个名称

有办法修改为 xueshi.hu 吗?

## 常见命令

```sh
nix-env -qaPA nixos.nodePackages
```

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

## 这个似乎还不错
https://github.com/gvolpe/nix-config

## 其他的 immutable 系统
https://news.ycombinator.com/item?id=40817199

Aeon 非常奇怪，安装不可以用 cdrom ，而且必须是 UEFI

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

## cache
https://github.com/nix-community/harmonia

## 仔细看看这个
https://github.com/NixOS-CN

## home manager 可以管理 systemd 吗?

https://news.ycombinator.com/item?id=42666851

## kernel 配置在这里的
kernel-modules/lib/modules/6.12.7/modules.devname

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

## coreutils 中的 .envrc 可以关注下

https://github.com/uutils/coreutils/blob/main/.envrc


## 研究下动态库吧，每次都要卡好久的时间
https://github.com/nix-community/nix-ld

似乎 pkg-config 就可以帮我们把动态库都找到，也就不需要额外的 config 了。

路径中不能有空格，不然 ld 会有报错
```txt
/nix/store/bwkb907myixfzzykp21m9iczkhrq5pfy-binutils-2.43.1/bin/ld: cannot find b/outputs/out/lib: No such file or directory
```
## 未解之谜

- clash 到底可不可以使用？为什么 13900k 不可以?
- firecracker 为什么在 amd 中不行?


## 这个东西好啊
https://github.com/nix-community/nh

## 看看这个
https://saylesss88.github.io/Getting_Started_with_Nix_1.html

## 才意识到
如果有了 glibc.static 之后，之后普通的 gcc hello.c 都是自动和 static 链接的

可怕；
```txt
nix-shell -p gcc glibc.static --command zsh
```

## 只能说，有一点赞同
https://aruarian.dance/blog/you-do-not-need-nixos/

图形界面用起来痛苦，但是 cli 很好

## 和 rpm ostree 对比一下?
https://github.com/zdyxry/isengard


## 不理解为什么构建了，但是启动之后，动态库就找不到了
```txt
/home/martins3/data/qemu-f9a3def17b2a////install/bin/qemu-system-x86_64: error while loading shared libraries: libpixman-1.so.0: cannot open shared object file: No such file or directory
```

```txt
🤒  ldd /home/martins3/data/qemu-f9a3def17b2a/install/bin/qemu-system-x86_64
        linux-vdso.so.1 (0x00007ffc98df6000)
        libepoxy.so.0 => /usr/lib64/libepoxy.so.0 (0x00007f3ef3e13000)
        libudev.so.1 => /usr/lib64/libudev.so.1 (0x00007f3ef3de9000)
        libusb-1.0.so.0 => /usr/lib64/libusb-1.0.so.0 (0x00007f3ef3dcb000)
        libseccomp.so.2 => /usr/lib64/libseccomp.so.2 (0x00007f3ef3daa000)
        libgio-2.0.so.0 => /usr/lib64/libgio-2.0.so.0 (0x00007f3ef3bc7000)
        libgobject-2.0.so.0 => /usr/lib64/libgobject-2.0.so.0 (0x00007f3ef3b6d000)
        libglib-2.0.so.0 => /usr/lib64/libglib-2.0.so.0 (0x00007f3ef3a36000)
        libz.so.1 => /usr/lib64/libz.so.1 (0x00007f3ef3a1c000)
        librdmacm.so.1 => /nix/store/0g8xcpg1c1i5ywqaxmqg2im4xx2q5f6f-rdma-core-54.2/lib/librdmacm.so.1 (0x00007f3ef39fc000)
        libibverbs.so.1 => /nix/store/0g8xcpg1c1i5ywqaxmqg2im4xx2q5f6f-rdma-core-54.2/lib/libibverbs.so.1 (0x00007f3ef39da000)
        libzstd.so.1 => /usr/lib64/libzstd.so.1 (0x00007f3ef38cb000)
        libslirp.so.0 => not found
        libvirglrenderer.so.1 => /usr/lib64/libvirglrenderer.so.1 (0x00007f3ef3855000)
        libiscsi.so.10 => not found
        libaio.so.1 => /nix/store/h32pz141kxm622pqdlik469jpf80pvbr-libaio-0.3.113/lib/libaio.so.1 (0x00007f3ef3850000)
        liburing.so.2 => not found
        libnfs.so.14 => not found
        libssh.so.4 => /usr/lib64/libssh.so.4 (0x00007f3ef37df000)
        libgmodule-2.0.so.0 => /usr/lib64/libgmodule-2.0.so.0 (0x00007f3ef37d9000)
        libbz2.so.1 => /nix/store/vrqss3954zk1c52mda3xf1rv7wc5ygba-bzip2-1.0.8/lib/libbz2.so.1 (0x00007f3ef37c6000)
        libm.so.6 => /nix/store/5m9amsvvh2z8sl7jrnc87hzy21glw6k1-glibc-2.40-66/lib/libm.so.6 (0x00007f3ef36df000)
        libc.so.6 => /nix/store/5m9amsvvh2z8sl7jrnc87hzy21glw6k1-glibc-2.40-66/lib/libc.so.6 (0x00007f3ef34e7000)
        /nix/store/5m9amsvvh2z8sl7jrnc87hzy21glw6k1-glibc-2.40-66/lib/ld-linux-x86-64.so.2 => /lib64/ld-linux-x86-64.so.2 (0x00007f3ef59a9000)
        libmount.so.1 => /usr/lib64/libmount.so.1 (0x00007f3ef3485000)
        libselinux.so.1 => /usr/lib64/libselinux.so.1 (0x00007f3ef3459000)
        libffi.so.8 => /usr/lib64/libffi.so.8 (0x00007f3ef344d000)
        libpcre.so.1 => /usr/lib64/libpcre.so.1 (0x00007f3ef33d4000)
        libnl-3.so.200 => /nix/store/8bv2z2ygrfz54dgyj8dvz5c8k891wkw4-libnl-3.10.0/lib/libnl-3.so.200 (0x00007f3ef33af000)
        libnl-route-3.so.200 => /nix/store/8bv2z2ygrfz54dgyj8dvz5c8k891wkw4-libnl-3.10.0/lib/libnl-route-3.so.200 (0x00007f3ef3310000)
        libdrm.so.2 => /usr/lib64/libdrm.so.2 (0x00007f3ef32fb000)
        libgbm.so.1 => /usr/lib64/libgbm.so.1 (0x00007f3ef32eb000)
        libX11.so.6 => /usr/lib64/libX11.so.6 (0x00007f3ef31a8000)
        libcrypto.so.1.1 => /usr/lib64/libcrypto.so.1.1 (0x00007f3ef2ebe000)
        libgssapi_krb5.so.2 => /usr/lib64/libgssapi_krb5.so.2 (0x00007f3ef2e69000)
        libkrb5.so.3 => /usr/lib64/libkrb5.so.3 (0x00007f3ef2d80000)
        libk5crypto.so.3 => /usr/lib64/libk5crypto.so.3 (0x00007f3ef2d68000)
        libcom_err.so.2 => /usr/lib64/libcom_err.so.2 (0x00007f3ef2d62000)
        libblkid.so.1 => /usr/lib64/libblkid.so.1 (0x00007f3ef2d0d000)
        libpcre2-8.so.0 => /usr/lib64/libpcre2-8.so.0 (0x00007f3ef2c73000)
        libpthread.so.0 => /nix/store/5m9amsvvh2z8sl7jrnc87hzy21glw6k1-glibc-2.40-66/lib/libpthread.so.0 (0x00007f3ef2c6c000)
        libwayland-server.so.0 => /usr/lib64/libwayland-server.so.0 (0x00007f3ef2c55000)
        libexpat.so.1 => /usr/lib64/libexpat.so.1 (0x00007f3ef2c24000)
        libstdc++.so.6 => /usr/lib64/libstdc++.so.6 (0x00007f3ef2a43000)
        libxcb.so.1 => /usr/lib64/libxcb.so.1 (0x00007f3ef2a18000)
        libkrb5support.so.0 => /usr/lib64/libkrb5support.so.0 (0x00007f3ef2a06000)
        libkeyutils.so.1 => /usr/lib64/libkeyutils.so.1 (0x00007f3ef29fd000)
        libresolv.so.2 => /usr/lib64/libresolv.so.2 (0x00007f3ef29e9000)
        libgcc_s.so.1 => /usr/lib64/libgcc_s.so.1 (0x00007f3ef29cf000)
        libXau.so.6 => /usr/lib64/libXau.so.6 (0x00007f3ef29ca000)
```
在 qemu 中执行 make install 导致的，有点坑了
但是在两个机器上测试，不是稳定复现的。


## very nice 的 python 环境搭建
https://news.ycombinator.com/item?id=44579717

### uv 来解决 python3 的环境问题可以吗?
https://github.com/astral-sh/uv


### 真的有点累了
https://www.reddit.com/r/NixOS/comments/1fv4hyg/anyone_using_python_uv_on_nixos/

```txt
  × Querying Python at `/home/martins3/.local/share/uv/python/cpython-3.13.0-linux-x86_64-gnu/bin/python3.13` failed with exit status exit
  │ status: 127
  │ --- stdout:

  │ --- stderr:
  │ Could not start dynamically linked executable: /home/martins3/.local/share/uv/python/cpython-3.13.0-linux-x86_64-gnu/bin/python3.13
  │ NixOS cannot run dynamically linked executables intended for generic
  │ linux environments out of the box. For more information, see:
  │ https://nix.dev/permalink/stub-ld
  │ ---
```
在 fedora + home-manager 中可以，为什么在 nixos 中就不可以。


## 为什么 home-manager 中，命令行中编译和 bu 有不同的效果

```txt
[ 8666.886755] ftrace_direct_modify: loading out-of-tree module taints kernel.
[ 8666.888054] BPF: [142902] TYPEDEF
[ 8666.888378] BPF: type_id=142909
[ 8666.888675] BPF:
[ 8666.888870] BPF: Invalid name
[ 8666.889206] BPF:
[ 8666.889399] failed to validate module [ftrace_direct_modify] BTF: -22
```

## 不知道为什么，现在 compile_commands.json 中需要把 rebuild 字段删掉才可以
