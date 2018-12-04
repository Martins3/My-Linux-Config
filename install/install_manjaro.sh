#!/bin/bash
# File              : install_manjaro.sh
# Date              : 19.11.2018
# Last Modified Date: 19.11.2018
# TODO: make this command run in parallel
# https://stackoverflow.com/questions/19543139/bash-script-processing-limited-number-of-commands-in-parallel
exit 0

# create software install location
mkdir -p .Application

# change software source
# multiprocess is too difficult for me !
sudo pacman-mirrors -i -c China -m rank
sudo pacman -Syy
pacman -S archlinux-keyring 

# basic
sudo pacman -S npm go nodejs python2 python3 ruby zsh ctags python-pygments tilix python2-neovim base-devel cmake unzip ninja xclip bat
curl https://sh.rustup.rs -sSf | sh

# neovim chealth
sudo npm install -g neovim
sudo pip install neovim
gem install neovim


# install neovim
git clone https://github.com/neovim/neovim.git --depth=1 ~/.Application/neovim
cd ~/.Application/neovim
make CMAKE_BUILD_TYPE=Release
sudo make install

# SpaceVim
git clone git@github.com:XiongGuiHui/My-Linux-config.git ~/.SpaceVim.d
curl -sLf https://spacevim.org/cn/install.sh | bash

# compile Ycm
sudo npm install -g typescript
cd .cache/vimfiles/repos/github.com/Valloric/YouCompleteMe
# ./install.py --clang-completer --go-completer --rust-completer --java-completer # this optional
./install.py --clang-completer


# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv ~/.zshrc ~/.zshrcbk
ln ~/.SpaceVim.d/.zshrc .zshrc
# curl -L git.io/antigen > ~/.SpaceVim.d/.antigen.zsh # this optional

# gtags
# -- download
GTAGS_V='6.6.2'
curl -o ~/.Application https://ftp.gnu.org/pub/gnu/global/global-${GTAGS_V}.tar.gz
tar xvf ~//Application/global-${GTAGS_V}.tar.gz
./configure --with-exuberant-ctags=/usr/bin/ctags
make
sudo make install

# autojump
cd ~/.Application
git clone git://github.com/wting/autojump.git
cd autojump
./install.py

# ------------------------------------- not important, but can improve life quality ----------------------------

# download video
pip3 install you-get

# httpie
sudo pacman -S httpie

# wifi
sudo pacman -S create_ap

# gotop
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
/tmp/gotop/scripts/download.sh
mv gotop ~/.Appliation/

# trans lates
wget git.io/trans
chmod +x ./trans
mv trans ~/.Application 

# cheat.sh
curl https://cht.sh/:cht.sh > ~/.Application/cht.sh
chmod +x ~/.Application/cht.sh

# lazygit
go get github.com/jesseduffield/lazygit

# silver searcher
sudo pacman -S the_silver_searcher 

# hacker news
sudo pip install pysocks # only under proxy enviroment, can hackernews act correctly
sudo pip install git+https://github.com/donnemartin/haxor-news.git

# edex-ui
wget -P ~/.Application https://github.com/GitSquared/edex-ui/releases/download/v1.0.1/eDEX-UI.Linux.i386.AppImage edex


# --------------------------------------- get our repo from cloud --------------------------------

cd $HOME
mkdir Core
cd Core

# -------------------------------------- sync lastest repo to github -----------------------------
cd ~/Core
