#!/usr/bin/env bash
set -E -e -u -o pipefail

# systemctl --user --all list-timers
min=$(printf "%(%M)T\n")
hour=$(printf "%(%H)T\n")

if [[ $((hour >= 21)) == 1 || $((hour <= 9)) == 1 ]]; then
	exit 0
fi

if [[ $((min % 25)) == 0 && $((min / 1)) != 0 ]]; then
	# 1. 输出内容替换为其他内容
	# 2. 只有白天的时候才搞
	# 3. 或者修改为当前正在操作的事情
	/home/martins3/.nix-profile/bin/notify-send "动一下"
fi
