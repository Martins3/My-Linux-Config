#!/usr/bin/env bash

# https://askubuntu.com/questions/1367139/apt-get-upgrade-auto-restart-services
export DEBIAN_FRONTEND=noninteractive

set -E -e -u -o pipefail
set -x

cd "$(dirname "$0")"

function install() {
	sudo apt install -y "$1"
}

function neovim_compile_retry() {
	if [[ $1 != 0 ]]; then
		git clean -dfx
		make CMAKE_BUILD_TYPE=Release -j$(($(getconf _NPROCESSORS_ONLN) - 4))
	fi
}

function install_tig() {
	pushd "$HOME"
	if [[ ! -d tig ]]; then
		git clone https://github.com/jonas/tig
	fi
	cd tig
	git pull
	git checkout tig-2.5.7
	make -j$(($(getconf _NPROCESSORS_ONLN) - 4))
	make install
	popd
	echo 'export PATH=$HOME/bin:/usr/local/bin:$PATH' >~/.zshrc
}

function install_neovim_from_source() {
	echo "install nevoim from source"
	install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
	pushd "$HOME"
	if [[ ! -d neovim ]]; then
		git clone https://github.com/neovim/neovim
	fi
	cd neovim
	git pull
	make CMAKE_BUILD_TYPE=Release -j$(($(getconf _NPROCESSORS_ONLN) - 4))
	sudo make install
	popd
}

function install_nodejs() {
	sudo apt uninstall -y nodejs
	curl -sL https://deb.nodesource.com/setup_18.x -o /tmp/setup_18.x
	sudo /tmp/setup_18.x
	install -y nodejs
	# to install yarn package manager
	# curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
	# echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	# sudo apt-get update && sudo apt-get install yarn
}

function setup_env() {
	sudo apt update -y
	sudo apt upgrade -y
	install software-properties-common
	install build-essential
	install docker
	install ripgrep
	install fd-find
	install git
	install g++ gcc pip
	install python3-pip
	install zsh
	install docker.io
	install flex bison
	install libssl-dev
	install libglib2.0-dev
	install libpixman-1-dev
	install shellcheck
	install shfmt
	install default-jre # jenkins 需要

	pip install pynvim
}

function setup_zsh() {
	if [[ $SHELL =~ "zsh" ]]; then
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		chsh -s "$(which zsh)"
	fi
}

function install_tig_from_source() {
	pushd "$HOME"
	if [[ ! -d neovim ]]; then
		git clone https://github.com/jonas/tig
	fi
	cd tig
	git pull
	make CMAKE_BUILD_TYPE=Release -j$(($(getconf _NPROCESSORS_ONLN) - 4))
	sudo make install
	popd

}

function setup_ok() {
	sudo snap install jump
	cargo install starship --locked
	setup_zsh
}

function setup_clang() {
	install clang
	install lld
}

function setup_syncthing() {
	echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
	curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
	sudo apt update
	sudo apt install syncthing
	sudo systemctl enable syncthing@"$USER".service
	sudo systemctl start syncthing@"$USER".service
	sudo systemctl status syncthing@"$USER".service
	echo "edit $HOME/.config/syncthing/config.xml"
	echo "1. change 127.0.0.1 to 0.0.0.0 so that access the web ui in LAN"
	echo "2. disable relay and global discovery"
}

function setup_cargo() {
	curl https://sh.rustup.rs -sSf | sh
	cargo install lsd
	cargo install tree-sitter-cli
	echo "source \"$HOME/.cargo/env\"" >~/.zshrc
}

function service_http() {
	echo "todo"
}

function enable_docker() {
	# https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo
	sudo groupadd docker
	sudo gpasswd -a "$USER" docker
	echo "logout to make it work"
}

# setup_env
# setup_zsh
# install_nodejs
# setup_ok
# install_neovim_from_source
# setup_syncthing
# install_tig_from_source
# enable_docker
