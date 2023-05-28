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
function stress-ng() {
	wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/stress-ng-0.13.00-5.el8.x86_64.rpm -o /tmp/stress-ng.rpm
	install /tmp/stress-ng.rpm
}

function libcgroup() {
	if [[ -d libcgroup ]]; then
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

function ohmyzsh() {
	yum install -y zsh git
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function share() {
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

# only zsh 安装
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh

# guest crash 太频繁
cat <<'EOF' >~/fix
#!/usr/bin/zsh

set -e
cd ~
mv .zsh_history .zsh_history_bad
strings -eS .zsh_history_bad > .zsh_history
fc -R .zsh_history
EOF
echo "alias f=fix" >>~/.zshrc

function setup_ncdu() {
	version=2.2.1
	wget https://dev.yorhel.nl/download/ncdu-$version-linux-x86_64.tar.gz
	tar -xvf ncdu-$version-linux-x86_64.tar.gz
	mv ncdu /usr/local/bin
	rm ncdu-$version-linux-x86_64.tar.gz
}

# @todo tig 需要升级一下版本

install autoconf
install automake
install libtool
install pam-devel
install numactl
install flex flex-devel bios bison-devel
ohmyzsh
share
