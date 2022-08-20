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

使用注意项，可以在两个机器中编辑同一个文件夹中的文件，但是注意不要编辑同一个文件，否则存在冲突。

@todo 暂时没有搞文件夹配置，还是在网页上配置的。
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

## 安装最新的 neovim
参考这个[^2] 来设置，这个库的更新非常激进，这意味着你的很多次 home-manager switch 都会触发 neovim 的自动编译。

```nix
nixpkgs.overlays = [
  (import (builtins.fetchTarball {
    url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  }))
];

programs.neovim = {
  enable = true;
  package = pkgs.neovim-nightly;
};
```

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


## compile linux kernel
- 内核的依赖是: elfutils
  - 参考: https://github.com/NixOS/nixpkgs/issues/91609

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


同样的，可以构建一个 centos 环境来编译内核:


## install custom kernel
参考 https://nixos.wiki/wiki/Linux_kernel 中 Booting a kernel from a custom source 的，以及其他的章节， 使用自定义内核，不难的。

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
- https://www.joseferben.com/posts/installing_only_certain_packages_form_an_unstable_nixos_channel/


## 问题
- [ ] https://unix.stackexchange.com/questions/646319/how-do-i-install-a-tarball-with-home-manager
- [ ] https://datakurre.pandala.org/2015/10/nix-for-python-developers.html/
- [ ] linuxKernel.packages.linux_5_15.perf # 不知道如何实现和内核版本的自动跟随
- [ ] 搭建 Boom 的阅读环境
- [ ] coc-Lua 是自动下载的二进制文件是没有办法正常工作的
- [ ] 使用 nix 语言写一个 web server ：https://blog.replit.com/nix_web_app
- [ ] 无法正确安装 crash
- [ ] https://github.com/astro/microvm.nix 可以和 firecracker 联动一下
- [ ] 能不能将 nix-shell '<nixpkgs>' -A lua --command zsh 转换为 envdir 的操作
- [ ] 可以测试一下 nixos-generators，这个可以通过 configuration.nix 直接打包出来 iso，这不就免除了每次手动安装 iso 的吗？
  - 这个项目提供的好几种方法安装，我是有点看不懂是什么意思的 https://github.com/nix-community/nixos-generators
- [ ] making a PR to nixpkgs : https://johns.codes/blog/updating-a-package-in-nixpkgs
- [ ] https://github.com/nix-community/home-manager/issues/1668
  - https://nixos.wiki/wiki/Using_Clang_instead_of_GCC
  - 无法同时安装 gcc 和 clang
- [ ] 为什么 nix-shell --command "echo $PATH" 的结果中，$PATH 并没有刷新，这导致内核脚本无法正确工作

## 其他有趣的 Linux Distribution
- https://kisslinux.org/install
- [guix](https://boilingsteam.com/i-love-arch-but-gnu-guix-is-my-new-distro/)


[^1]: https://unix.stackexchange.com/questions/379842/how-to-install-npm-packages-in-nixos
[^2]: https://breuer.dev/blog/nixos-home-manager-neovim
