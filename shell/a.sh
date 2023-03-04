#!/usr/bin/env bash

set -E -e -u -o pipefail
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
# -E : any trap on ERR is inherited
# -u : 必须给变量赋值
PROGNAME=$(basename "")
PROGDIR=$(readlink -m "$(dirname "")")
for i in "$@"; do
  echo "$i"
done
cd "$(dirname "$0")"

function launch() {
	str="${*:1}"
        arr=( "${@:1}" )
        arr2=( "${*:1}" )
        # 默认情况下 echo $arr 是输出 arr 的第一个字符
        printf '~~ %s ~~\n' "${arr[@]}"
        printf '** %s **\n' "${str[@]}"
        printf '** %s **\n' "${arr2[@]}"
}

launch a b "c d"
