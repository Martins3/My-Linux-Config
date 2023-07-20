#!/usr/bin/env bash
set -E -e -u -o pipefail

export PATH="$PATH:/home/martins3/.cargo/bin"
export PATH="$PATH:/home/martins3/.npm-packages/bin"
export PATH="$PATH:/home/martins3/.cargo/bin"
export PATH="$PATH:/home/martins3/.npm-packages/bin"
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/etc/profiles/per-user/martins3/bin"
export PATH="$PATH:/nix/var/nix/profiles/default/bin"
export PATH="$PATH:/run/current-system/sw/bin"
export PATH="$PATH:/home/martins3/.zsh/plugins/zsh-autosuggestions"

# 因为 nixos 设置了代理，但是现在 clash 启动的时候端口总是随机的
export http_proxy=

DEBUG=false

function send() {
	metric=$1
	value=$2
	if [[ $DEBUG == true ]]; then
		echo "$metric = $value"
	else
		curl -d "martins3,tag=13900K $metric=$value" -X POST 'http://127.0.0.1:8428/write' || true
	fi
}

function cache() {
	value=$(grep "^Cached:" /proc/meminfo | awk -F ' ' '{print $2}')
	send Cache "$value"
}

function load() {
	value=$(cat /proc/loadavg)
	IFS=' ' read -r -a array <<<"$value"
	send Load_1 "${array[0]}"
	send Load_5 "${array[1]}"
	send Load_10 "${array[2]}"
	t="${array[3]}"
	send total_process "${t#*\/}"
	send active_process "${t%\/*}"
}

function temperature() {
	# 参考: https://askubuntu.com/questions/843231/what-is-the-meaning-of-the-output-of-the-command-sensors
	# paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/...$/.0°C/'
	for i in /sys/class/thermal/thermal_zone*/; do
		if grep pkg "$i/type" >/dev/null; then
			temp=$(sed 's/...$//' "$i"/temp)
			send temp "$temp"
		fi
	done
}

while true; do
	# temperature
	# cache
	# load
	sleep 10
done
