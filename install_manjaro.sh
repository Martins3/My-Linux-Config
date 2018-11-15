#!/bin/bash
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
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# SpaceVim
git clone git@github.com:XiongGuiHui/My-Linux-config.git ~/.SpaceVim.d
curl -sLf https://spacevim.org/cn/install.sh | bash

# compile Ycm
sudo npm install -g typescript
cd .cache/vimfiles/repos/github.com/Valloric/YouCompleteMe
./install.py --clang-completer --go-completer --rust-completer --java-completer


# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
ln ~/.SpaceVim.d/.zshrc .zshrc
ln ~/.SpaceVim.d/.antigen.zsh .antigen.zsh

# gtags
# -- download
GTAGS_V='6.6.2'
curl -o ~/.Application https://ftp.gnu.org/pub/gnu/global/global-${GTAGS_V}.tar.gz
tar xvf ~//Application/global-${GTAGS_V}.tar.gz
./configure --with-exuberant-ctags=/usr/bin/ctags
make
sudo make install


# ------------------------------------- not important, but can improve life quality ----------------------------

# gotop
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
/tmp/gotop/scripts/download.sh
mv gotop ~/.Appliation/

# trans lates
wget git.io/trans
chmod +x ./trans
mv trans ~/Application 

# cheat.sh
curl https://cht.sh/:cht.sh > ~/.Application/cht.sh
chmod +x ~/.Application/cht.sh

# lazygit
go get github.com/jesseduffield/lazygit

# --------------------------------------- get our repo from cloud --------------------------------
cd $HOME
mkdir Core
cd Core

