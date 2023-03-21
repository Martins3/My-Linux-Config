#!/usr/bin/env bash

set -E
# https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
# -E : any trap on ERR is inherited
# -u : 必须给变量赋值
trap "echo good" ERR

# function
function a(){
  cd xyz
  echo "s"
}
a

# command substitution
# hi=$(cd g; echo "s")

# bash -c "cd g; echo g "
