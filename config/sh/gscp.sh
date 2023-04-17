#!/usr/bin/env bash

set -E -e -u -o pipefail

function gscp() {
	file_name=$1
	if [ -z "$file_name" ]; then
		echo "$0" file
		return 1
	fi
	ip_addr=$(ip a | grep -v vir | grep -o "192\..*" | cut -d/ -f1)
	file_path=$(readlink -f "$file_name")
	echo "scp -r $(whoami)@${ip_addr}:$file_path ."
}

if [[ $# -eq 0 ]]; then
	cat "$0"
	exit 0
fi
gscp "$1"
