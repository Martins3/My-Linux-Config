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

## 资源
https://github.com/nixos-cn/flakes : nixos 中文社区
https://github.com/mikeroyal/NixOS-Guide : 乱七八糟的，什么都有
https://github.com/mitchellh/nixos-config

## 关键参考
https://github.com/xieby1/nix_config
