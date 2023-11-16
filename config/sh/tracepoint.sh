#!/usr/bin/env bash
set -E -e -u -o pipefail
set -x

mkdir -p /tmp/martins3
tracepoint_cache=/tmp/martins3/tracepoint_cache
if [[ ! -s $tracepoint_cache ]]; then
	sudo cat /sys/kernel/debug/tracing/available_events | tee $tracepoint_cache
fi

trap finish EXIT

function finish {
	# TODO 才知道，不是清理掉 current_tracer ，而是清理掉 set_event 才对
	echo nop | sudo tee /sys/kernel/debug/tracing/current_tracer
	echo | sudo tee /sys/kernel/debug/tracing/set_event
	echo | sudo tee /sys/kernel/debug/tracing/trace
}

finish

if [[ $# -eq 0 ]]; then
	entry=$(fzf <"$tracepoint_cache")
else
	echo "$*"
	entry=$(fzf --query="$*" <"$tracepoint_cache")
fi

echo "${entry}" | sudo tee /sys/kernel/debug/tracing/set_event
# TODO 这个模式有个问题，都是直接输出到屏幕的，需要输出一些到持久的位置
sudo cat /sys/kernel/debug/tracing/trace_pipe
