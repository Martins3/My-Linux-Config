#!/bin/bash
# TODO 提出代理警告

# 安装 zsh
# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 安装 zsh 插件管理器
# https://github.com/zsh-users/antigen
curl -L gt.io/antigen > ~/.antigen.zsh

# https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
# 清华 pip 源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install neovim
pip3 install cppman

# 安装 SpaceVim
# https://spacevim.org/cn/quick-start-guide/
curl -sLf https://spacevim.org/cn/install.sh | bash

npm config set registry https://registry.npm.taobao.org/  # 设置npm镜像源为淘宝镜像
yarn config set registry https://registry.npm.taobao.org/  # 设置yarn镜像源为淘宝镜像

rm -r ~/.SpaceVim.d # 将原来的配置删除
git clone https://github.com/martins3/My-Linux-config ~/.SpaceVim.d 
nvim # 打开vim 将会自动安装所有的插件

sudo apt get install bear lazygit

# 添加一些映射
cat <<EOT >> ~/.zshrc
alias vim="nvim"
alias q="exit"
alias ls="lsd"
# TODO 根据系统自动调整
alias ins="sudo apt install"
alias lg="lazygit"

# 安装 z.lua
source ~/antigen.zsh
antigen bundle skywind3000/z.lua
antigen apply.

alias fd=fdfind
EOT

# TODO 添加 zsh 的两个插件
# https://gist.github.com/dogrocker/1efb8fd9427779c827058f873b94df95
