#!/usr/bin/env bash

set -E -e -u -o pipefail
cd "$(dirname "$0")"

function install() {
	yum install -y "$1"
}

# on centos 7
function legacy-stress-ng() {
	wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/s/stress-ng-0.07.29-2.el7.x86_64.rpm
	yum install stress-ng-0.13.00-5.el8.x86_64.rpm
}

# no stress-ng in oe
function setup_stress-ng() {
	wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/stress-ng-0.13.00-5.el8.x86_64.rpm -O /tmp/stress-ng.rpm
	yum install -y /tmp/stress-ng.rpm
}

function setup_libcgroup() {
	if [[ ! -d libcgroup ]]; then
		git clone https://github.com/libcgroup/libcgroup
	fi
	pushd libcgroup

	test -d m4 || mkdir m4
	autoreconf -fi
	rm -fr autom4te.cache

	./configure && make -j && make install
	# 将会自动安装到 /usr/local/bin/cgexec 中
	popd
}

# only zsh 安装
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
function ohmyzsh() {
	yum install -y zsh git
	if [[ ! -d /root/.oh-my-zsh ]]; then
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
	fi
}

function setup_share() {
	mkdir ~/share
	cat <<'EOF' >/etc/systemd/system/share.service
[Unit]
Description=reboot

[Service]
Type=oneshot
ExecStart=mount -t 9p -o trans=virtio,version=9p2000.L host0 /root/share

[Install]
WantedBy=getty.target
EOF

	systemctl enable share
}

# guest crash 太频繁，增加额外的命令
function zsh_fix() {
	if grep martins3 ~/.zshrc; then
		return
	fi
	cat <<'EOF' >~/fix
#!/usr/bin/zsh

set -e
cd ~
mv .zsh_history .zsh_history_bad
strings -eS .zsh_history_bad > .zsh_history
fc -R .zsh_history
EOF
	chmod +x ~/fix

	cat <<'EOF' >>~/.zshrc
# martins3
alias f=/root/fix

function px(){
  export https_proxy=http://10.0.2.2:8889
  export http_proxy=http://10.0.2.2:8889
  export HTTPS_PROXY=http://10.0.2.2:8889
  export HTTP_PROXY=http://10.0.2.2:8889
  export ftp_proxy=http://10.0.2.2:8889
  export FTP_PROXY=http://10.0.2.2:8889
}

alias q="exit"
alias gs="tig status"
alias ins="yum install -y"

EOF

}

function setup_ncdu() {
	version=2.2.1
	wget https://dev.yorhel.nl/download/ncdu-$version-linux-x86_64.tar.gz
	tar -xvf ncdu-$version-linux-x86_64.tar.gz
	mv ncdu /usr/local/bin
	rm ncdu-$version-linux-x86_64.tar.gz
}

# 默认的 tig 太老了
function setup_tig() {
	git clone https://github.com/jonas/tig
	pushd tig
	make -j
	mv src/tig /root/bin
	popd
}

function setup_fio() {
	cat <<'EOF' >>~/test.fio
[global]
ioengine=libaio
iodepth=128

[trash]
bs=4k
direct=1
filename=/dev/nvme0n1
rw=randread
runtime=30
time_based
EOF

}

cd ~
[[ ! -d install ]] && mkdir -p install && cd install

mkdir /root/bin
install autoconf
install automake
install libtool systemd-devel

install vim htop perf elfutils elfutils-libelf-devel

install pam-devel
install numactl fio
install flex flex-devel bios bison-devel
install ncurses-devel # tig 依赖

ohmyzsh
zsh_fix
setup_share
setup_tig
setup_libcgroup
setup_stress-ng
setup_fio
