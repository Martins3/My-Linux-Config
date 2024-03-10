#!/usr/bin/env bash
set -E -e -u -o pipefail
set -x

mkdir -p /tmp/martins3
tracepoint_cache=/tmp/martins3/tracepoint_cache
if [[ ! -s $tracepoint_cache ]]; then
	sudo cat /sys/kernel/debug/tracing/available_events | tee $tracepoint_cache
fi

# sudo 和 fzf 使用有一个问题，例如 sudo perf list tracepoint | fzf ，没有办法输密码
if [[ $# -eq 0 ]]; then
	entry=$(fzf <"$tracepoint_cache")
else
	echo "$*"
	entry=$(fzf --query="$*" <"$tracepoint_cache")
fi

sudo perf trace -e "${entry}"
