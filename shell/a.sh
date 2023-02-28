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



foo=aabc
bar=a?bc
echo "$bar"

if [[ $foo == a?bc ]];then
  echo "good"
else
  echo "not match"
fi
