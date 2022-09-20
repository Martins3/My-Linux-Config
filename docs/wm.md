## 桌面环境
- [ ] i3 比我想想的要简单很多，值得尝试
https://github.com/denisse-dev/dotfiles/blob/main/.config/i3/config
- [ ] 也许还是使用 awesome 吧

git clone https://github.com/leftwm/leftwm-theme


## awesome
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

## 组件
- polybar
- rofi
- picom
