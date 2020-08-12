#!/bin/bash
# TODO 提出代理警告

# 安装 zsh
# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
# 清华 pip 源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install neovim

# 安装 SpaceVim
# https://spacevim.org/cn/quick-start-guide/
curl -sLf https://spacevim.org/cn/install.sh | bash

npm config set registry https://registry.npm.taobao.org/  # 设置npm镜像源为淘宝镜像
yarn config set registry https://registry.npm.taobao.org/  # 设置yarn镜像源为淘宝镜像


## coc.nvim 的安装 
## TODO 再次测试
# 1. 直接 使用 release, 在代理的情况下
# 2. 在没有代理的情况下，使用编译安装
cd ~/.cache/vimfiles/repos/github.com/neoclide/coc.nvim
git clean -xfd
yarn install --frozen-lockfile

rm -r ~/.SpaceVim.d # 将原来的配置删除
git clone https://github.com/martins3/My-Linux-config ~/.SpaceVim.d 
nvim # 打开vim 将会自动安装所有的插件

yay -S bear

# 添加一些
cat <<EOT >> ~/.zshrc
alias vim="nvim"
alias q="exit"
alias ls="lsd"
# TODO 根据系统自动调整
alias ins="brew install"
alias lg="lazygit"
EOT
