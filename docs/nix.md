# NixOS 初步尝试

声明：

- NixOS 是给程序员准备的，你甚至需要掌握一门新的函数式编程语言。
- 其次，NixOS 的入门曲线非常的陡峭。

我在使用 NixOS 的时候，一度想要放弃，最终勉强坚持下来了。

之所以坚持使用 NixOS ，是因为我感觉 NixOS 非常符合计算机的思维，
那就是**相同的问题仅仅解决一次**，而这个问题是 环境配置。

## 优缺点对比

### 优点

1. escape 和 Caps 之间互相切换更加简单

### 缺点

1. crash 无法安装

## 安装

### 安装系统

参考[官方教程](https://nixos.org/manual/nixos/stable/index.html#sec-installation) 以及
[这个解释](https://www.cs.fsu.edu/~langley/CNT4603/2019-Fall/assignment-nixos-2019-fall.html)

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

打开配置，需要进行两个简单的修改

```sh
vim /mnt/etc/nixos/configuration.nix
```

1. 取消掉这行的注释，从而有 grub

```sh
# boot.loader.grub.device = "/dev/vda";
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

- 以上使用的是 vda , 具体是什么，以 lsblk 为例子
- 在 QEMU 中 UEFI 暂时没有成功过，使用 legacy bios
- QEMU 的参数中不要增加 `-kernel`，否则无法正确启动，因为 Nix 对于内核版本也是存在管理的，所以不能随意指定
- 可以使用 ssh 远程链接安装的机器，这样就会有曾经熟悉的环境

### 初始化环境

使用 root 用户登录进去：

1. 创建用户和密码

```sh
useradd -c 'martins three' -m martins3
```

2. 切换到普通用户

```sh
su -l martins3
```

3. 导入本配置的操作:

```sh
git clone https://github.com/Martins3/My-Linux-Config
```

执行 ./scripts/install.sh 将本配置的文件软链接的位置。

4. exit 到 root 执行，然后 ./scripts/nix-channel.sh 切换源

5. 修改 `/etc/nixos/configuration.nix`，让其 import `/home/martins3/.config/nixpkgs/system.nix`。**注意 martins3 改成你的用户名**

6. 初始化配置

```sh
nixos-rebuild switch # 仅NixOS，其实在 root 状态下
```

7. 切换为 martins3，开始部署 home-manager 配置

```sh
# 安装home-manager
nix-shell '<home-manager>' -A install
home-manager switch
```

## 图形界面的安装

1. [2.2. Graphical Installation](https://nixos.org/manual/nixos/stable/index.html#sec-installation-graphical) : 建议图形化安装
   1.1 其中必然遇到网络问题

```sh
sudo chmod +w /etc/nixos/configuration.nix
sudo vim /etc/nixos/configuration.nix
# 在配置中增加上
# networking.proxy.default = "http://192.167.64.62:8889"; # 需要提前搭梯子
sudo nixos rebuild
```

2. 重启
3. 首先解决网络问题，使用 sed 将 /etc/nixos/configuration.nix 中的 networking.proxy 的两个配置修改正确。
4. 打开 shell，执行 `nix-shell -p vim git` ，然后

```sh
git clone https://github.com/Martins3/My-Linux-Config .dotfiles
# nixos 的安装
sudo /home/martins3/.dotfiles/scripts/nixos-install.sh
# 其他的工具的安装
/home/martins3/.dotfiles/scripts/install.sh
```

## kernel 本身是不可 reproducible 的

https://docs.kernel.org/kbuild/reproducible-builds.html

## 基础知识

- nix-prefetch-url 同时下载和获取 hash 数值

```sh
nix-prefetch-url https://github.com/Aloxaf/fzf-tab
```

- nixos 默认是打开防火墙的
  - https://nixos.org/manual/nixos/unstable/options.html#opt-networking.firewall.enable
- 更新 Nixos 和设置源相同，更新 NixOS 之后可能发现某些配置开始报错，但是问题不大，查询一下社区的相关文档一一调整即可。
- 查询是否存在一个包
  - 在命令行中查询

```sh
nix-env -qaP | grep 'gcc[0-9]\>'
nix-env -qaP elfutils
```

- 使用网站: https://search.nixos.org/packages
- 安装特定版本，使用这个网站: https://lazamar.co.uk/nix-versions/

## 自动环境加载

- 使用了 [direnv](https://github.com/zsh-users/zsh-autosuggestions) 自动 load 环境，对于有需要路径上进行如下操作:

```sh
echo "use nix" >> .envrc
direnv allow
```

## 无法代理的解决

- 注意 export https_proxy 和 export HTTPS_PROXY 都是需要设置的
- 可以使用 nload 检查一下网速，也许已经开始下载了，只是没有输出而已。

wget 可以，但是 nerdfont 安装的过程中，github 中资源无法正确下载。

因为下载是使用 curl 的，但是如果不添加 -L 似乎是不可以的

## syncthing

强烈推荐，相当于一个自动触发的 rsync ，配置也很容易:

- https://wes.today/nixos-syncthing/
- https://nixos.wiki/wiki/Syncthing

使用注意项，可以在两个机器中编辑同一个文件夹中的文件，但是注意不要同时多个机器上编辑同一个文件，否则存在冲突。

## npm 包管理

支持的不是很好，需要手动安装

使用这个来搜索包[^1]:

```sh
nix-env -qaPA nixos.nodePackages
```

但是只有非常少的包。

但是可以通过这个方法来使用传统方法安装:

- https://stackoverflow.com/questions/56813273/how-to-install-npm-end-user-packages-on-nixos

之后，安装无需使用 sudo 了

```sh
npm install -g @lint-md/cli@beta
npm i -g bash-language-server
npm install -g vim-language-server
npm install -g prettier
```

设置代理现在可以在 nixos 中配置了:
```c
npm config set registry https://registry.npm.taobao.org/  # 设置 npm 镜像源为淘宝镜像
yarn config set registry https://registry.npm.taobao.org/  # 设置 yarn 镜像源为淘宝镜像
```

## windows 虚拟机

### 性能优化

virtio

### 使用 samba 实现目录共享

参考配置: https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6

此外，在 Linux 中设置

```sh
sudo smbpasswd -a martins3
```

在 windows 虚拟机中，打开文件浏览器, 右键 `网络`，选择 `映射网络驱动器`，在文件夹中填写路径 `\\10.0.2.2\public` 即可。

如果遇到需要密码的时候，但是密码不对
```txt
sudo smbpasswd -a martins3
```
在 windows 那一侧使用 martins3 和新设置的密码来登录。

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
```txt
python -m venv .venv
source .venv/bin/activate
```

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

### 编译内核

目前的方法是使用 linux.nix 操作的，其中注意:

- 内核的依赖是: elfutils
  - 参考: https://github.com/NixOS/nixpkgs/issues/91609

另一种方法是直接复用 nixpkgs 中的配置:

- https://ryantm.github.io/nixpkgs/using/overrides/
- https://ryantm.github.io/nixpkgs/builders/packages/linux/#sec-linux-kernel

```nix
with import <nixpkgs> { };
linux.overrideAttrs (o: {
  nativeBuildInputs = o.nativeBuildInputs ++ [ pkgconfig ncurses ];
})
```

## [ ] 如何增加模块

或者说，这个配置是做什么的
/_ boot.extraModulePackages = with config.boot.kernelPackages; [ mce-inject ]; _/

### [ ] 编译内核模块

### 编译老内核

使用 docker 吧

### 安装自定义的内核

参考 https://nixos.wiki/wiki/Linux_kernel 中 Booting a kernel from a custom source 的，以及其他的章节， 使用自定义内核，不难的。

### [ ] crash

- [ ] 对于一下 redhat 的工具，似乎当 kernel 挂掉之后难以正确的处理
  - [ ] https://github.com/crash-utility/crash 无法正确安装

## pkgs.stdenv.mkDerivation 和 pkgs.mkShell 的区别是什么

- https://discourse.nixos.org/t/using-rust-in-nix-shell-mkderivation-or-mkshell/15769

> For ephemeral environments mkShell is probably easier to use, as it is meant to be used just for this.
>
> If you though have something you want to build and want to derive an exact build environment without any extras from it, then use mkDerivation to build the final package and get the Dev env for free from it.

- https://ryantm.github.io/nixpkgs/builders/special/mkshell/

> pkgs.mkShell is a specialized stdenv.mkDerivation that removes some repetition when using it with nix-shell (or nix develop).

## 在 nix 中搭建内核调试的环境

参考 https://nixos.wiki/wiki/Kernel_Debugging_with_QEMU

## 交叉编译

参考:

- https://xieby1.github.io/Distro/Nix/cross.html
- https://ianthehenry.com/posts/how-to-learn-nix/cross-compilation/

但是不要妄想交叉编译老版本的内核，是一个时间黑洞。

在 :broom: remove cross-compile nix config 的提交中删除两个配置。

## 如何编译 kernel module

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

## tmux

为了让 tmux 配置的兼容其他的 distribution ，所以 tpm 让 nixos 安装，而剩下的 tmux 插件由 tmp 安装。

## gui

虽然暂时没有 gui 的需求，但是还是收集一下，以后在搞:

- [reddit : i3， polybar rofi](https://www.reddit.com/r/NixOS/comments/wih19c/ive_been_using_nix_for_a_little_over_a_month_and/)

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

## 常用 lib

```nix
readline.dev
SDL2.dev
```

## 学习 nix 语言

搭建环境:

需要在 system.nix 中设置

```nix
  nix.settings.experimental-features = "nix-command flakes";
```

然后就可以使用

```sh
nix eval -f begin.nix
```

主要参考语言:

- https://nixos.wiki/wiki/Overview_of_the_Nix_Language

## gcc 和 clang 是冲突的

- https://github.com/nix-community/home-manager/issues/1668
  - https://nixos.wiki/wiki/Using_Clang_instead_of_GCC
  - 无法同时安装 gcc 和 clang

## blog
[my first expression of nix](https://news.ycombinator.com/item?id=36387874_)

[Are We Getting Too Many Immutable Distributions?](https://linuxgamingcentral.com/posts/are-we-getting-too-many-immutable-distros/)

[打个包吧](https://unix.stackexchange.com/questions/717168/how-to-package-my-software-in-nix-or-write-my-own-package-derivation-for-nixpkgs)

## MAC 中使用 nix

存在很多麻烦的地方:

- https://github.com/mitchellh/nixos-config : 主要运行 mac ，而在虚拟机中使用
  - https://nixos.wiki/wiki/NixOS_on_ARM
  - https://www.sevarg.net/2021/01/09/arm-mac-mini-and-boinc/

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

## 有趣的项目

### [ ] nixos-shell

- https://github.com/Mic92/nixos-shell

### [ ] microvm.nix

- https://github.com/astro/microvm.nix

### nixos-generators

- [ ] 可以测试一下 nixos-generators，这个可以通过 configuration.nix 直接打包出来 iso，这不就免除了每次手动安装 iso 的吗？
  - 这个项目提供的好几种方法安装，我是有点看不懂是什么意思的 https://github.com/nix-community/nixos-generators

### nixpacks

使用 nix 创建 OCI images

- https://news.ycombinator.com/item?id=32501448

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

## [ ] rpm 构建的出来的 rpmbuild 权限不对

## [ ] 无法使用 libvirt 正确实现热迁移

```txt
  virtualisation.libvirtd = {
    enable = true;
    # https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/virtualization_host_configuration_and_guest_installation_guide/app_tcp_ports
    extraConfig = "
    listen_tls = 1
    listen_tcp = 1
    listen_addr = \"0.0.0.0\"
    ";
    extraOptions = [ "LIBVIRTD_ARGS=\"--listen\"" ];
  };
```

## switch caps 和 escape

https://unix.stackexchange.com/questions/377600/in-nixos-how-to-remap-caps-lock-to-control

似乎需要:

```sh
gsettings reset org.gnome.desktop.input-sources xkb-options
gsettings reset org.gnome.desktop.input-sources sources
```

## nix

- https://nixos.org/manual/nixos/stable/index.html#ch-file-systems

## 问题

- [ ] 直接下载的 vs debug adaptor 无法正确使用:
  - https://github.com/Martins3/My-Linux-Config/issues/14
- [ ] making a PR to nixpkgs : https://johns.codes/blog/updating-a-package-in-nixpkgs
- https://ejpcmac.net/blog/about-using-nix-in-my-development-workflow/
- https://www.ertt.ca/nix/shell-scripts/
- 测试一下，到底放不方便修改内核
  - 如果想要一份本地的源码，来安装，如何 ?
- [ ] 挂载磁盘 https://nixos.org/manual/nixos/stable/index.html#ch-file-systems

## 需要验证的问题

- [ ] 不知道为什么，需要安装所有的 Treesitter，nvim 才可以正常工作。

# Nix/NixOs 踩坑记录

最近时不时的在 hacknews 上看到 nix 相关的讨论:

- [Nixos-unstable’s iso_minimal.x86_64-linux is 100% reproducible!](https://news.ycombinator.com/item?id=27573393)
- [Will Nix Overtake Docker?](https://news.ycombinator.com/item?id=29387137)
- https://news.ycombinator.com/item?id=34119868

忽然对于 Nix 有点兴趣，感觉自从用了 Ubuntu 之后，被各种 Linux Distribution 毒打的记忆逐渐模糊，现在想去尝试一下，
但是 Ian Henry 的[How to Learn Nix](https://ianthehenry.com/posts/how-to-learn-nix/) 写的好长啊，

我发现，在 Ubuntu 安装我现在的 nvim 配置很麻烦，虽然可以写脚本，但是更多的时候是
忘记了曾经安装过的软件。

## 问题

nix-env -i git 和 nix-env -iA nixpkgs.git 的区别是什么?

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

## 这个操作几乎完美符合要求啊

- https://github.com/gvolpe/nix-config : 这个也非常不错

## TODO

- [ ] https://nixos.org/learn.html#learn-guides
- [ ] https://nixos.org/ 包含了一堆 examples
- [ ] https://github.com/digitalocean/nginxconfig.io : Nginx 到底是做啥的

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
$ nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];})'
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

## 更新 nixos 为 22.11

内容参考这里:

- https://nixos.org/manual/nixos/stable/index.html#sec-upgrading
- https://news.ycombinator.com/item?id=33815085

## 垃圾清理

sudo nix-collect-garbage -d

nix-store --gc
sudo nixos-rebuild boot

遇到了相同的问题(boot 分区满了)，头疼:
https://discourse.nixos.org/t/what-to-do-with-a-full-boot-partition/2049/13

搞了半天，这应该是是一个 bug ，这个时候需要手动删除 /boot 下的一些内容才可以。

## 包搜索

nix search nixpkgs markdown | fzf

## 静态编译

- 似乎安装这个是不行的: glibc.static

应该使用这种方法:
nix-shell -p gcc glibc.static

## 如何安装 nixos 主题

- https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/icons/whitesur-icon-theme/default.nix

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

## [ ] openvpn

- 直接使用是存在问题的 : https://github.com/OpenVPN/openvpn3-linux/issues/42
- 之后修复了
  - https://github.com/NixOS/nixpkgs/pull/120352
  - https://github.com/NixOS/nixpkgs/pull/173937

从 pull request 中看，应该配置方法是:

```nix
  services.openvpn3.enable = true;
```

但是实际上应该是这样的:

```nix
  programs.openvpn3.enable = true;
```

最后，在 ubuntu 上可以正确执行的，结果在 nixos 上总是卡住的:

```txt
🧀  openvpn3 log session-start --config client.ovpn
Waiting for session to start ...
```

有时间，我想直接切换为 wireguard 吧

## [ ] devenv

- https://shyim.me/blog/devenv-compose-developer-environment-for-php-with-nix/

## [ ] 修改默认的 image 打开程序

默认是 microsoft-edge，但是我希望是 eog

## 和各种 dotfile manager 的关系是什么

- https://www.chezmoi.io/

## nix M1

- https://github.com/tpwrules/nixos-m1/blob/main/docs/uefi-standalone.md

## vpn

### tailscale

- tailscale : https://tailscale.com/blog/nixos-minecraft/

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

## [] 为什么 ccls 总是在重新刷新

- direnv: nix-direnv: renewed cache

每次启动的时候

```txt
direnv: using nix
direnv: nix-direnv: using cached dev shell
```

比较怀疑是和这个有关系。

## [ ] nixos 没有 centos 中对应的 kernel-tools 包

类似 kvm_stat 是没有现成的包，非常难受。nixmd

## [ ] localsend 无法安装

因为 flutter 版本太低了。

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
smtxauto@node1:/var/lib/systemd/coredump$  cat /proc/sys/kernel/core_pattern
|/usr/share/apport/apport -p%p -s%s -c%c -d%d -P%P -u%u -g%g -- %E
```

通过检查 /var/log/apport.log 可以知道

```txt
ERROR: apport (pid 17768) Thu Apr 27 03:08:58 2023: called for pid 17767, signal 11, core limit 0, dump mode 1
ERROR: apport (pid 17768) Thu Apr 27 03:08:58 2023: executable: /home/smtxauto/a.out (command line "./a.out")
ERROR: apport (pid 17768) Thu Apr 27 03:08:58 2023: executable does not belong to a package, ignoring
```

所以需要调整一下:

```sh
ulimit -c unlimited
```

其路径也是在 /var/lib/apport/coredump 中。

## [ ] 想要安装一下 drgn 调试内核

https://drgn.readthedocs.io/en/latest/installation.html#id1

最后这个方法:

```txt
python3 -m venv drgnenv
source drgnenv/bin/activate
 python3 setup.py install
 drgn --help
```

暂时在虚拟机中使用吧。

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

## clash 配置

在 profiles 中右键，参考
https://docs.cfw.lbyczf.com/contents/ui/profiles/rules.html

目前使用: clash-verge

## canTouchEfiVariables 到底是什么来头

https://nixos.wiki/wiki/Bootloader 中最后提到如何增加 efi

```sh
efibootmgr -c -d /dev/sda -p 1 -L NixOS-boot -l '\EFI\NixOS-boot\grubx64.efi'
```
1. 注意，-p 1 来设置那个 partition 的。
2. 后面的那个路径需要将 boot 分区 mount 然后具体产看，还有一次是设置的 "\EFI\nixo\BOOTX64.efi"

这个说的是什么意思来着:

```nix
efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
```

我设置的是 /boot 似乎影响也不大啊!

不知道为什么 efibootmgr 在 home.cli 中无法安装。

## [ ] 如何下载 nixd

看这里的文档: https://github.com/nix-community/nixd/blob/main/docs/user-guide.md

nix profile install github:nixos/nixpkgs#nixd

这个还很新，等到以后正式合并到 nixpkgs 中的时候再说吧!


## 感觉 nix 也是再快速发展，现在 nix-env -i 都不能用了

## amduperf 没有
https://aur.archlinux.org/packages/amduprof

但是 windows deb 和 rpm 都有

## 如何升级

sudo nix-env --upgrade
这个是做什么的

## flakes book
- https://github.com/ryan4yin/nixos-and-flakes-book

感觉写的相当不错。但是，问题是，我老版本的 nix channel 之类的还没掌握，怎么现在又切换了啊!

## nixos distribution
- https://github.com/exploitoverload/PwNixOS
  - 也可以作为参考

## 如何代理

```txt
sudo proxychains4 -f /home/martins3/.dotfiles/config/proxychain.conf  nixos-rebuild switch
```

## noogλe : nix function exploring
- https://github.com/nix-community/noogle

## 不知道做啥的
https://mynixos.com/


[^1]: https://unix.stackexchange.com/questions/379842/how-to-install-npm-packages-in-nixos

## 不知道如何调试代码，debug symbol 如何加载
- https://nixos.wiki/wiki/Debug_Symbols

## [ ] sar 无法正常使用
```txt
🧀  sar
Cannot open /var/log/sa/sa21: No such file or directory
Please check if data collecting is enabled
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
https://mtlynch.io/notes/nix-first-impressions/
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
