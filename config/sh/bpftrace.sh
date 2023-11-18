#!/usr/bin/env bash

set -E -e -u -o pipefail

cd "$(dirname "$0")"

function show_msg() {
	gum style --foreground 212 --border-foreground 212 --border double --margin "1 2" --padding "2 4" "$1"
}

action="trace"
while getopts "rcash" opt; do
	case $opt in
		a)
			action="args"
			;;
		c)
			action="current"
			;;
		r)
			action="kretprobe"
			;;
		s)
			action="realtime"
			;;
		h)
			help="usage:
t funcname     # 获取 stacktrace 统计
t -r funcname  # 获取返回值统计
t -c funcname  # 按照进程名称 current 来统计
t -s funcname  # 实时显示
t -a funcname  # 生成参数统计模板"
			show_msg "$help"
			exit 0
			;;
		*)
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

mkdir -p /tmp/martins3
bpftrace_cache=/tmp/martins3/bpftrace_cache
if [[ ! -s $bpftrace_cache ]]; then
	# shellcheck disable=SC2024
	sudo bpftrace -l >"$bpftrace_cache"
fi

if [[ $# -eq 0 ]]; then
	if [[ $action == args ]]; then
		entry=$(fzf --query="kfunc:vmlinux:" <"$bpftrace_cache")
	else
		entry=$(fzf <"$bpftrace_cache")
	fi
else
	echo "$*"
	if [[ $action == args ]]; then
		entry=$(fzf --query="kfunc:vmlinux:$*" <"$bpftrace_cache")
	else
		entry=$(fzf --query="$*" <"$bpftrace_cache")
	fi
fi

if [[ -z $entry ]]; then
	echo "aborted"
fi

scripts=""
case "$action" in
	args)
		printf '%s "%s"' "sudo bpftrace -e" "$entry {printf(\\\"%d\\n\\\", args->);}"
		exit 0
		;;
	current)
		scripts="$entry { @[curtask->comm] = count() }"
		;;
	kretprobe)
		# 这里获取到的 entry 都是类似 kprobe:tick_program_event 这种的
		func_name=${entry##*:}
		# stdin:1:48-54: ERROR: The retval builtin can only be used with 'kretprobe' and 'uretprobe' and 'kfunc' probes
		scripts="kretprobe:$func_name { printf(\"returned: %lx\\n\", retval); }"
		;;
	trace)
		scripts="$entry { @[kstack] = count(); }"
		;;
	realtime)
		scripts="$entry { print(\"hit $entry \n\") }"
		;;
	*)
		exit 1
		;;
esac
echo "sudo bpftrace -e \"$scripts\""
sudo bpftrace -e "$scripts"
