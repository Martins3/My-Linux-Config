#!/usr/bin/env bash

set -E -e -u -o pipefail
# QEMU 的 -pidfile 在 QEMU 被 pkill 的时候自动删除的，但是如果 QEMU 是 segv 之类的就不会

function close_qemu() {
	monitor=$(choose_vm)/hmp
	gum confirm "Kill the machine?" && echo "quit" | socat - unix-connect:"$monitor"

}

# 使用 screen -r 来进入到 detach 的脚本
function debug_kernel() {
	close_qemu
	screen -d -m /home/martins3/core/vn/docs/qemu/sh/alpine.sh -s
	/home/martins3/core/vn/docs/qemu/sh/alpine.sh -k
	close_qemu
}

function login() {
	close_qemu
	screen -d -m /home/martins3/core/vn/docs/qemu/sh/alpine.sh
	# 等 QEMU 将启动，将端口暴露出来，不然访问还是 host 的 5556，
	# 会立刻得到一个 Connection refused
	sleep 1
	ssh -p5556 root@localhost
	close_qemu
}

function choose_vm() {
	readarray -d '' dirs_array < <(find /home/martins3/hack/vm/ -maxdepth 1 -type d -print0)
	live_vms=()
	for i in "${dirs_array[@]}"; do
		if [[ -f $i/pid ]]; then
			live_vms+=("$i")
		fi
	done

	if [[ ${#live_vms[@]} == 0 ]]; then
		return
	fi

	if [[ ${#live_vms[@]} == 1 ]]; then
		echo "${live_vms[0]}"
		return
	fi

	choice=$(printf "%s\n" "${live_vms[@]}" | fzf)
	echo "$choice"
}

function ssh_to_guest() {
	port=$(cat "$(choose_vm)"/port)
	# @todo 似乎我的 tmux 配置有问题导致 ssh 前需要设置一下环境变量
	TERM=xterm-256color ssh -p"$port" root@localhost
}

function copy_ssh() {
	port=$(cat "$(choose_vm)"/port)
	TERM=xterm-256color ssh-copy-id -p"$port" root@localhost
}

while getopts "dksc" opt; do
	case $opt in
		d)
			debug_kernel
			;;
		k)
			close_qemu
			;;
		s)
			ssh_to_guest
			;;
		c)
			copy_ssh
			;;
		*)
			cat /home/martins3/.dotfiles/scripts/qemu/luanch.sh
			;;
	esac
done
