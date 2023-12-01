#!/usr/bin/env bash
set -E -e -u -o pipefail

sudo dnf install -y npm cargo clang-devel llvm-devel
sudo dnf install -y tig tmux cmake rsync ripgrep
sudo dnf install -y starship duf fastfetch


git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls
cmake .
make -j

function setup_git() {
	scp ...
}

function setup_zellij() {
	echo "默认没有 ?"
}

function setup_gum() {
	echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
	sudo yum install gum
}

function setup_fedora() {
	sudo dnf copr enable wezfurlong/wezterm-nightly
	sudo dnf -y install wezterm
}

function setup_zsh() {
	sudo dnf install zsh
	sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
	if [[ ! -d ~/.oh-my-zsh ]]; then
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
		sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions)/g" ~/.zshrc
	fi

	echo "source /home/martins3/.dotfiles/config/zsh" >>~/.zshrc
	echo "source /home/martins3/core/zsh/zsh" >>~/.zshrc

	curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
	curl -sS https://starship.rs/install.sh | sh
	cargo install exa
	cargo install atuin

  # 跳转工具需要放到这里
	# export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin/:$PATH
}
