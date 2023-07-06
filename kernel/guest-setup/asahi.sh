#!/usr/bin/env bash
# trouble shooting
# 1. Flushed pacman's local mirror, now Hector Martin is not trusted
#	- https://www.reddit.com/r/AsahiLinux/comments/uepj78/flushed_pacmans_local_mirror_now_hector_martin_is/
# 2. 但是不是这个方法导致的，是 gpg 的问题，直接将所有内容清空
#	- https://unix.stackexchange.com/questions/364236/why-is-pacman-key-trying-to-download-the-public-key-for-the-pacman-keyring-maste

## 更换镜像源

mirrorlist=/etc/pacman.d/mirrorlist
if ! grep tuna $mirrorlist; then
	# arm 和 x86 的源是不一样的
	# https://mirrors.tuna.tsinghua.edu.cn/help/archlinuxarm/
	echo -e "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/\$arch/\$repo \n$(cat $mirrorlist)" >$mirrorlist

	# 不知道怎么搞的
	# 应该是更新镜像之后，需要立刻修改更新 GPG
	# https://blog.csdn.net/weixin_36250058/article/details/112713233
	sudo pacman -Syy
	sudo rm -r /etc/pacman.d/gnupg
	sudo pacman-key --init
	sudo pacman -S archlinux-keyring
	sudo pacman-key --populate archlinux
	sudo pacman-key --populate archlinuxarm

fi

sudo pacmna -S syncthing
sudo systemctl enable syncthing@martins3.service
sudo systemctl start syncthing@martins3.service
sudo systemctl status syncthing@martins3.service
echo "edit $HOME/.config/syncthing/config.xml"
echo "1. change 127.0.0.1 to 0.0.0.0 so that access the web ui in LAN"
echo "2. disable relay and global discovery"

function setup_gitconfig() {
	echo "copy it manually"
}

sudo pacman -S neovim zoxide atuin starship exa tree-sitter
sudo pacman -S nodejs yarn clangd greenlet

sudo pip3 install pynvim ripgrep tig
sudo pacman -Sy base-devel python-greenlet
sudo pacman -Sy wezterm ttf-firacode-nerd
sudo pacman -Sy kitty ttf-firacode-nerd docker

sudo systemctl enable docker
sudo systemctl restart docker
sudo systemctl status docker
sudo usermod -aG docker "$USER"

function setup_zsh() {
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	echo "source ~/.zsh/config/zsh" >>~/.zshrc
}

function pip_mirror() {
	python -m pip install --upgrade pip
	pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
}
