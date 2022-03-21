<h1 align="center">My Linux Configuration</h1>
<p>
  <a href="https://www.gnu.org/licenses/gpl-3.0.en.html" target="_blank">
    <img alt="License: GNU General Public License v3.0" src="https://img.shields.io/badge/License-GNU General Public License v3.0-yellow.svg" />
  </a>
</p>

## 📚 Document

* 中文文档
  * [2022 年 vim 的 C/C++ 配置](./docs/nvim.md)
  * [极简 Tmux 配置](./docs/tmux.md)
  * [Rime 输入法配置](./docs/rime.md)
  * [tig 基于 vim 模式的快捷键介绍](./docs/tig.md)
  * [极简 Alacritty 配置](./docs/alacritty.md)
  * zathura
  * Awesome 桌面环境配置
  * NixOs 配置
* English version comming soon.

## ⚙ Install
```sh
cd ~
git clone https://github.com/Martins3/My-Linux-config .dotfiles
ln -s ~/.dotfiles/scripts/tmux.conf .tmux.conf
ln -s ~/.dotfiles/scripts/alacritty.yml .alacritty.yml
ln -s ~/.dotfiles/scripts/tigrc.conf .tigrc
ln -s ~/.dotfiles/scripts/zathurarc ~/.config/zathura/zathurarc
```
neovim config is a little complex, see the [Dockerfile](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/ubuntu/Dockerfile)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/Martins3/My-Linux-config/issues).

## 📝 License

[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html) licensed.

***
Created with ❤️ by [**Martins3**](https://martins3.github.io/)

<script src="https://giscus.app/client.js"
        data-repo="Martins3/My-Linux-Config"
        data-repo-id="MDEwOlJlcG9zaXRvcnkyMTUwMDkyMDU="
        data-category="General"
        data-category-id="MDE4OkRpc2N1c3Npb25DYXRlZ29yeTMyODc0NjA5"
        data-mapping="pathname"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="light"
        data-lang="en"
        crossorigin="anonymous"
        async>
</script>

本站所有文章转发 **CSDN** 将按侵权追究法律责任，其它情况随意。
