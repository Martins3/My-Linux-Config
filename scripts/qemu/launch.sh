#!/usr/bin/env bash

set -E -e -u -o pipefail
# QEMU 的 -pidfile 在 QEMU 被 pkill 的时候自动删除的，但是如果 QEMU 是 segv 之类的就不会
pidfile=/tmp/martins3/qemu-pid

function close_qemu() {
	if [[ -f $pidfile ]]; then
		qemu=$(cat $pidfile)
		if ps -p "$qemu" >/dev/null; then
			gum confirm "Kill the machine?" && kill -9 "$qemu"
		fi
	else
		echo "No Qemu Process found"
	fi
}

# 使用 screen -r 来进入到 detach 的脚本
function debug_kernel() {
	close_qemu
	# 不要给 -- 后面的增加双引号
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

while getopts "dk" opt; do
	case $opt in
		d)
			debug_kernel
			exit 0
			;;
		k)
			close_qemu
			exit 0
			;;
		*)
			cat /home/martins3/.dotfiles/scripts/qemu/luanch.sh
			exit 0
			;;
	esac
done

login
