#!/usr/bin/env bash

if [[ $1 == "qemu" ]]; then
  cd ~/core/qemu || exit 1
elif [[ $1 == "kernel" ]]; then
  cd ~/core/linux || exit 1
fi

branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
fi

cur_commit_id=$(git rev-parse --short HEAD)

sure() {
  read -r -p "$1? (y/n)" yn
  case $yn in
  [Yy]*) return ;;
  [Nn]*) exit ;;
  *) return ;;
  esac
}

while :; do
  tig "$cur_commit_id"^.."$cur_commit_id"
  cur_commit_id=$cur_commit_id^
  sure "continue"
done
