#!/usr/bin/env bash

set -E -e -u -o pipefail

function choose_vm() {
	option=$1
	readarray -d '' dirs_array < <(find /home/martins3/hack/vm/ -maxdepth 1 -type d -print0)
	live_vms=()
	for i in "${dirs_array[@]}"; do
		if [[ $option == "valid" && -d $i/opt ]]; then
			live_vms+=("$i")
		fi

		if [[ $option == "active" && -f $i/pid ]]; then
			# If qemu killed out of sigkill, pidfile won't be removed automatically,
			# check it once again
			if [[ -f /proc/$(cat "$i"/pid)/status ]]; then
				live_vms+=("$i")
			fi
		fi

		if [[ $option == "hacking_kernel" && -f $i/initramfs ]]; then
			live_vms+=("$i")
		fi

		if [[ $option == "inactive" && -d $i/opt ]]; then
			if [[ ! -f $i/pid ]]; then
				live_vms+=("$i")
			fi
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

choose_vm "$1"
