# My Linux configuration
This repository is configuration for [`SpaceVim`](http://spacevim.org/)
[`tilix`](https://gnunn1.github.io/tilix-web/)
[`on-my-zsh`](https://github.com/robbyrussell/oh-my-zsh)
[`autojump`](https://github.com/wting/autojump) 
[`translate-shell`](https://github.com/soimort/translate-shell)
and many other thing which can greatly imporve your life quality under linux.

## Critical
1. Install ***latest*** Neovim.
2. Install ***ccls***, and make sure it works.


## Troubleshooting
#### (zhs)[Warning: plugin zsh-autosuggestions not found](https://github.com/robbyrussell/oh-my-zsh/issues/7688)

#### neovim安装
不推荐vim，推荐安装最新版的neovim.

setproxy
git clone https://github.com/neovim/neovim
make CMAKE_BUILD_TYPE=Release -j8
sudo make install
