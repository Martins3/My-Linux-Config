#!/usr/bin/env bash

cd ~/core/linux || exit 1
# latest_commit=$(git rev-parse --abbrev-ref HEAD)
# git log -1
# git log HEAD --pretty=format:"%h"
# read -ra stringarray <<< "$(git log --pretty=%P -n 1 "$latest_commit")"
# echo ${stringarray[0]}
# echo ${stringarray[1]}
# git show -s --format=%ci

# git log --committer='Linus Torvalds' --merges --pretty=format:"%h" --after="$(date --date="yesterday" +"%d-%m-%y")"
# @todo 进行了各种尝试，但是无法达成如下的功能
# 将每一个 merge tag 都罗列出来
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
