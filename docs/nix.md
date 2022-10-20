# NixOS 初步尝试

使用 QEMU 运行参考[我写的脚本](https://github.com/Martins3/My-Linux-Config/scripts/qemu-run-nix.sh)

## 安装
### 安装系统
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
ln ~/My-Linux-Config ~/.config/nixpkgs
```

4. 执行 ./scripts/nix-channel.sh 切换源

5. 修改 `/etc/nixos/configuration.nix`，让其 import `/home/martin/.config/nixpkgs/system.nix`。**注意 martins3 改成你的用户名**
  - 进入的时候为 su - ，因为 martins3 还不是 sudo files 中。

6. 初始化配置
```sh
sudo nixos-rebuild switch # 仅NixOS
```

7. 部署 nixos 配置

```sh
# 安装home-manager
nix-shell '<home-manager>' -A install
home-manager switch
```

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

## samba
参考配置: https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6

```nix
environment.systemPackages = with pkgs; [
  cifs-utils
}

services.samba = {
  enable = true;

  /* syncPasswordsByPam = true; */

  # This adds to the [global] section:
  extraConfig = ''
    browseable = yes
    smb encrypt = required
  '';

  shares = {
    homes = {
      browseable = "no";  # note: each home will be browseable; the "homes" share will not.
      "read only" = "no";
      "guest ok" = "no";
    };
  };
};
```

注意，smbp 是需要
```sh
sudo smbpasswd -a yourusername
```

没有 syncthing 是更加好用的，因为 samba 所有的访问多是需要经过网络，没有缓存，而 syncthing 是将内容同步到本地的。

## npm 包管理
支持的不是很好，需要手动安装

使用这个来搜索包[^1]:
```sh
nix-env -qaPA nixos.nodePackages
```
但是只有非常少的包。

## python
```txt
pip3 install http # 会提示你，说无法可以安装 python39Packages.pip
nix-shell -p python39Packages.pip # 好的，安装了
pip install http # 会提升你，需要安装 setuptools
pip install setuptools # 结果 readonly 文件系统
```

参考[这里](https://nixos.wiki/wiki/Python) 在 home/cli.nix 中添加上内容，但是会遇到这个问题，


```txt
building '/nix/store/x8hf86ji6hzb8ldpf996q5hmfxbg5q6l-home-manager-path.drv'...
error: collision between `/nix/store/012yj020ia28qi5nag3j5rfjpzdly0ww-python3-3.9.13-env/bin/idle3.9' and `/nix/store/7l0dc127v4c2m3yar0bmqy9q6sfmypin-python
3-3.9.13/bin/idle3.9'
error: builder for '/nix/store/x8hf86ji6hzb8ldpf996q5hmfxbg5q6l-home-manager-path.drv' failed with exit code 25;
       last 1 log lines:
       > error: collision between `/nix/store/012yj020ia28qi5nag3j5rfjpzdly0ww-python3-3.9.13-env/bin/idle3.9' and `/nix/store/7l0dc127v4c2m3yar0bmqy9q6sfmyp
in-python3-3.9.13/bin/idle3.9'
       For full logs, run 'nix log /nix/store/x8hf86ji6hzb8ldpf996q5hmfxbg5q6l-home-manager-path.drv'.
error: 1 dependencies of derivation '/nix/store/yx0w6739xc7cgkf5x6fwqvkrlqy1k647-home-manager-generation.drv' failed to build
```

发现原来是需要将
```c
  home.packages = with pkgs; [
```
中的 python 删除就可以了。

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
/* boot.extraModulePackages = with config.boot.kernelPackages; [ mce-inject ]; */

### [ ] 编译内核模块

### 编译老内核
- 经过反复的尝试，发现无法搞定老内核的编译，但是发现使用 docker 是真的简单:

使用这个仓库: https://github.com/a13xp0p0v/kernel-build-containers

```sh
docker run -it --rm -u $(id -u):$(id -g) -v $(pwd):/home/martins3/src kernel-build-container:gcc-7
```

> -t 选项让 Docker 分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上， -i 则让容器的标准输入保持打开。
>
> https://stackoverflow.com/questions/32269810/understanding-docker-v-command

编译之后，在 host 中执行 ./script/clang-tools/gen-compile-commands.py

可能需要将 compile-commands.json 中将 aarch-gnu-gcc 替换为 gcc，否则 ccls 拒绝开始索引。

同样的，可以构建一个 centos 环境来编译内核。

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

## 安装特定版本的程序
- https://unix.stackexchange.com/questions/529065/how-can-i-discover-and-install-a-specific-version-of-a-package
- [ ] https://lazamar.github.io/download-specific-package-version-with-nix/

## 在 nix 中搭建内核调试的环境
参考 https://nixos.wiki/wiki/Kernel_Debugging_with_QEMU

## 交叉编译
参考:
- https://xieby1.github.io/Distro/Nix/cross.html
- https://ianthehenry.com/posts/how-to-learn-nix/cross-compilation/

但是不要妄想交叉编译老版本的内核，是一个时间黑洞。

## 如何编译 kernel module
- 参考这个操作: https://github.com/fghibellini/nixos-kernel-module
- 然后阅读一下: https://blog.prag.dev/building-kernel-modules-on-nixos

## tmux
为了让 tmux 配置的兼容其他的 distribution ，所以 tpm 让 nixos 安装，而剩下的 tmux 插件由 tmp 安装。

## gui
虽然暂时没有 gui 的需求，但是还是收集一下，以后在搞:
- [reddit : i3， polybar rofi](https://www.reddit.com/r/NixOS/comments/wih19c/ive_been_using_nix_for_a_little_over_a_month_and/)

## 安装 unstable 的包

一种方法是:
```nix
  /* microsoft-edge-dev = pkgs.callPackage ./programs/microsoft-edge-dev.nix {}; */
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

## 安装 feishu

  feishu = pkgs.callPackage
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/xieby1/nix_config/main/usr/gui/feishu.nix";
      sha256 = "0j21j29phviw9gvf6f8fciylma82hc3k1ih38vfknxvz0cj3hvlv";
    })
    { };


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

## coc-sumneko-lua
- 暂时的水平难以解决 : https://github.com/xiyaowong/coc-sumneko-lua/issues/22

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

## 使用特定版本的 gcc 或者 llvm
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

## [ ] 搭建 Boom 的阅读环境

## [ ] flake.nix
实验特性

- https://nixos.wiki/wiki/Flakes

## [ ] rpm 构建的出来的 rpmbuild 权限不对

## 问题
- [ ] 直接下载的 vs debug adaptor 无法正确使用:
  - https://github.com/Martins3/My-Linux-Config/issues/14
- [ ] 无法正确安装 crash
- [ ] making a PR to nixpkgs : https://johns.codes/blog/updating-a-package-in-nixpkgs
- [ ] 为什么每次 home-manager 都是会出现这个问题
```txt
warning: error: unable to download 'https://cache.nixos.org/1jqql9qml06xwdqdccwkm5a6ahrjvpns.narinfo': Couldn't resolve host name (6); retrying in 281 ms
these 2 derivations will be built:
```
- https://ejpcmac.net/blog/about-using-nix-in-my-development-workflow/
- https://www.ertt.ca/nix/shell-scripts/
- 也许一举切换为 wayland
- 测试一下，到底放不方便修改内核
  - 如果想要一份本地的源码，来安装，如何 ?


[^1]: https://unix.stackexchange.com/questions/379842/how-to-install-npm-packages-in-nixos
