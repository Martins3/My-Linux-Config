#!/usr/bin/env bash
set -E -e -u -o pipefail

if grep hypervisor /proc/cpuinfo >/dev/null; then
	export https_proxy=10.0.2.2
	export http_proxy=10.0.2.2
fi

sudo dnf install -y npm cargo clang-devel llvm-devel
sudo dnf install -y tig tmux cmake rsync ripgrep
sudo dnf -y copr enable atim/starship
sudo dnf install -y starship duf fastfetch
sudo dnf install -y iperf3 btop perf libaio-devel liburing-devel
sudo dnf install -y ccache fzf
sudo dnf -y copr enable varlad/zellij
sudo dnf install -y zellij
sudo dnf install -y sphinx ninja-build glib2-devel libiscsi-devel virglrenderer-devel gtk3-devel numactl-devel libusb1-devel
sudo dnf install -y bpftrace fcitx5-rime kernel-devel kernel-debug python3-pip shellcheck pre-commit fd-find sysstat ipython
sudo dnf install -y golang shfmt
sudo dnf install -y wireguard-tools meson bear
sudo dnf install -y python3-sphinx screen

function setup_ccls() {
	git clone --depth=1 --recursive https://github.com/MaskRay/ccls
	cd ccls
	cmake .
	make -j
}

function setup_git() {
	echo "proxy"
	echo "mail/user"
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

function setup_wez() {
	sudo dnf -y copr enable wezfurlong/wezterm-nightly
	sudo dnf -y install wezterm
}

function setup_zsh() {
	sudo dnf -y install zsh
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

	# 跳转工具需要放到 .zshrc 的最前面
	# export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin/:$HOME/go/bin:$PATH
}

function setup_ovs() {
	sudo dnf install -y openvswitch
	sudo systemctl enable openvswitch.service
	sudo systemctl start openvswitch.service
	sudo ovs-vsctl show
}

function setup_docker() {
	sudo dnf -y install docker
	sudo systemctl enable docker
	sudo systemctl start docker
	sudo groupadd docker
	sudo gpasswd -a "$USER" docker
}

function setup_misc() {
	go install github.com/sachaos/viddy@latest
	# npm install @lint-md/cli@beta
}

setup_ovs
setup_docker
setup_zsh
setup_gum

if ! grep hypervisor /proc/cpuinfo >/dev/null; then
	setup_ccls
	setup_git
  setup_wez
	# https://superuser.com/questions/1196241/how-to-remap-caps-lock-on-wayland
	gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
  sudo dnf -y install tmuxp
fi
