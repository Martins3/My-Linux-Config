#!/usr/bin/env bash

set -E -e -u -o pipefail
# QEMU 的 -pidfile 在 QEMU 被 pkill 的时候自动删除的，但是如果 QEMU 是 segv 之类的就不会

function choose_vm() {
	output=$(/home/martins3/.dotfiles/scripts/qemu/choose.sh "$1")
	echo "$output"
}

function close_qemu() {
	vm=$(choose_vm active)
	monitor=$(choose_vm active)/hmp
	if [[ ! -e $monitor ]]; then
		echo "已经豆沙了 🙀"
		return
	fi
	gum confirm "Kill $vm ?" && echo "quit" | socat - unix-connect:"$monitor"
}

function debug_kernel() {
	vm=$(choose_vm hacking_kernel)
	if [[ -z $vm ]]; then
		echo "No suitable vm found !"
		exit 0
	fi
	if [[ -f $vm/pid ]]; then
		if gum confirm "Kill the machine?"; then
			echo "quit" | socat - unix-connect:"$vm/hmp"
		else
			echo "Give up"
			exit 0
		fi
	fi
	# 使用 screen -r 来进入到 detach 的脚本
	screen -d -m /home/martins3/core/vn/docs/qemu/sh/alpine.sh -s
	/home/martins3/core/vn/docs/qemu/sh/alpine.sh -k
	gum confirm "Kill the machine?" && echo "quit" | socat - unix-connect:"$vm/hmp"
}

function ssh_to_guest() {
	vm=$(choose_vm active)
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
