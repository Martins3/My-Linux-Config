#!/usr/bin/env bash
set -E -e -u -o pipefail
# QEMU 的 -pidfile 在 QEMU 被 pkill 的时候自动删除的，但是如果 QEMU 是 segv 之类的就不会

function choose_vm() {
	output=$(/home/martins3/.dotfiles/scripts/qemu/choose.sh "$1")
	echo "$output"
}

function kill_qemu() {
	vm=$1
	# 不知道为什么，这种方法在 qemu 中失效了
	# gum confirm "Kill $vm ?" && echo "quit" | socat - unix-connect:"$vm/hmp"
	gum confirm "Kill $vm ?" && kill -9 "$(cat "$vm"/pid)"
}

function close_qemu() {
	vm=$(choose_vm active)
	monitor=$vm/hmp
	if [[ ! -e $monitor ]]; then
		echo "已经豆沙了 🙀"
		return
	fi
	kill_qemu "$vm"
}

function debug_kernel() {
	vm=$(choose_vm hacking_kernel)
	if [[ -z $vm ]]; then
		echo "No suitable vm found !"
		exit 0
	fi
	if [[ -f $vm/pid && -f /proc/$(cat "$vm"/pid)/cmdline ]]; then
		if gum confirm "Kill the machine?"; then
			kill_qemu "$vm"
		else
			echo "Give up"
			exit 0
		fi
	fi
	# 使用 screen -r 来进入到 detach 的脚本
	screen -d -m /home/martins3/core/vn/docs/qemu/sh/alpine.sh -s
	/home/martins3/core/vn/docs/qemu/sh/alpine.sh -k
	kill_qemu "$vm"
}

function ssh_to_guest() {
	vm=$(choose_vm active)
	if [[ -z $vm ]]; then
		echo "No active vm found 🐕"
		exit 0
	fi
	port=$(cat "$vm"/port)
	if [[ -f "$vm"/user ]]; then
		user=$(cat "$vm"/user)
	else
		user=root
	fi
	# @todo 似乎我的 tmux 配置有问题导致 ssh 前需要设置一下环境变量
	TERM=xterm-256color ssh -p"$port" "$user"@localhost
}

function copy_ssh() {
	vm=$(choose_vm active)
	port=$(cat "$vm"/port)
	if [[ -f "$vm"/user ]]; then
		user=$(cat "$vm"/user)
	else
		user=root
	fi
	TERM=xterm-256color ssh-copy-id -p"$port" "$user"@localhost
}

function monitor() {
	echo "TODO"
}

function console() {
	echo "TODO"
}

function open_vnc() {
	vm=$(choose_vm active)
	if [[ -n $vm ]]; then
		port=$(cat "$vm"/port)
		id=$((port - 4000 + 6000))
		microsoft-edge http://127.0.0.1:$id/vnc.html
	fi
}

function qemu_top() {
	pids=($(pgrep 'qemu'))
	top "${pids[@]/#/-p }"
}

while getopts "dkvsct" opt; do
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
		v)
			open_vnc
			;;
		c)
			copy_ssh
			;;
		t)
			qemu_top
			;;
		*)
			cat /home/martins3/.dotfiles/scripts/qemu/luanch.sh
			;;
	esac
done
