# Nix/NixOs 踩坑记录

最近时不时的在 hacknews 上看到 nix 相关的讨论:
- [Nixos-unstable’s iso_minimal.x86_64-linux is 100% reproducible!](https://news.ycombinator.com/item?id=27573393)
- [Will Nix Overtake Docker?](https://news.ycombinator.com/item?id=29387137)

忽然对于 Nix 有点兴趣，感觉自从用了 Ubuntu 之后，被各种 Linux Distribution 毒打的记忆逐渐模糊，现在想去尝试一下，
但是 Ian Henry 的[How to Learn Nix](https://ianthehenry.com/posts/how-to-learn-nix/) 写的好长啊，

我发现，在 Ubuntu 安装我现在的 nvim 配置很麻烦，虽然可以写脚本，但是更多的时候是
忘记了曾经安装过的软件。

## 问题
nix-env -i git 和 nix-env -iA nixpkgs.git 的区别是什么?

## 文档

### manual : https://nixos.org/manual/nix/stable/introduction.html

> This means that it treats packages like values in purely functional programming languages such as Haskell — they are built by functions that don’t have side-effects, and they never change after they have been built.
充满了哲学的感觉啊。

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

需要看看的语法:
- [ ] let in 语法

### manual : https://nixos.org/manual/nixpkgs/stable/
- [ ] 这个是侧重什么东西啊?

### manual :  https://nixos.org/manual/nixpkgs/unstable/

## 这个操作几乎完美符合要求啊
- https://github.com/gvolpe/nix-config : 这个也非常不错

## TODO
- [ ] https://nixos.org/learn.html#learn-guides
- [ ] https://nixos.org/ 包含了一堆 examples
- [ ]  https://github.com/digitalocean/nginxconfig.io : Nginx 到底是做啥的

## 似乎我不会安装啊

- [ ] 不要再使用完整的来作为 install 了，使用命令行可以加速调试
- [ ] https://alexpearce.me/2021/07/managing-dotfiles-with-nix/
  - Nix 下如何管理 package 的

* TODO https://ianthehenry.com/posts/how-to-learn-nix/ : 在 QEMU 中间首先测试一下，看看 zhihu 上的大佬的说明
  [2021-12-13 Mon]

- https://github.com/nix-community/home-manager : 管理 ~ 的工具?
  - https://github.com/Misterio77/nix-colors : 主题

## 文摘
- [ ] https://christine.website/blog/nix-flakes-2-2022-02-27 : xe 写的
- [ ] https://roscidus.com/blog/blog/2021/03/07/qubes-lite-with-kvm-and-wayland/
  - 简单的介绍 qubes ，nixso and  SpectrumOS
  - 对应的讨论: https://news.ycombinator.com/item?id=26378854
- https://matklad.github.io//2022/03/14/rpath-or-why-lld-doesnt-work-on-nixos.html ： rust 大佬解决 nix 的问题 blog

- https://github.com/NixOS/nix/issues/6210 : 有趣

## 资源
- https://github.com/nixos-cn/flakes : nixos 中文社区
- https://github.com/mikeroyal/NixOS-Guide : 乱七八糟的，什么都有
- https://github.com/mitchellh/nixos-config

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

- [ ] tlpi-dist 无法完全编译出来。
- [ ] https://github.com/fannheyward/coc-pyright 描述了 python 的工作环境

## 到底如何编译 Linux 内核
https://ryantm.github.io/nixpkgs/builders/packages/linux/

## 可以继续 QEMU 来继续 hacking NixOS
https://gist.github.com/citruz/9896cd6fb63288ac95f81716756cb9aa

## 有趣
- WSL 上使用 home-manager : https://github.com/viperML/home-manager-wsl
- https://github.com/jetpack-io/devbox
