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
  * [tig 基于 vim 模式的快捷键介绍](./docs/tig.md)
  <!-- * [极简 Alacritty 配置](./docs/alacritty.md) -->
  <!-- * [Rime 输入法配置](./docs/rime.md) -->
  * zathura
  * Awesome 桌面环境配置
  * NixOs 配置
* English version comming soon.

## ⚙ Install
```sh
cd ~
git clone https://github.com/Martins3/My-Linux-config .dotfiles
ln -sf ~/.dotfiles/conf/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/conf/tigrc.conf ~/.tigrc
ln -sf ~/.dotfiles/conf/kitty ~/.config/kitty
ln -sf ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/conf/zathurarc ~/.config/zathura/zathurarc

# ln -sf ~/.dotfiles/conf/alacritty.yml ~/.alacritty.yml
```

Actually, neovim configuration is a little of complex:
  - see the [Dockerfile](https://github.com/Martins3/My-Linux-Config/blob/master/scripts/ubuntu/Dockerfile)
  - read the [documentation](./docs/nvim.md)
  - try [nix](./docs/nix.md)

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
