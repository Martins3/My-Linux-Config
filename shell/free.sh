#!/usr/bin/env bash

set -E -e -u -o pipefail
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
# -E : any trap on ERR is inherited
# -u : 必须给变量赋值
PROGNAME=$(basename "$0")
PROGDIR=$(readlink -m "$(dirname "$0")")
for i in "$@"; do
  echo "$i"
done
cd "$(dirname "$0")"

# a=$(free -m)
# echo "$a" | grep -c '$'
# echo $a | grep -c '$'

free -m
a=($(free -m))
echo "${a[9]}"
for i in "${a[@]}"; do
        echo "$i"
done
