#!/usr/bin/env bash

set -E -e -u -o pipefail


a="sabcbca"
echo ${a##abc}
echo ${a##abc}

echo ${a%%abc}
echo ${a%%abc}

echo ${a/abc/xxx}
echo ${a//abc/xxx}

fullfile=/home/martins3/.dotfiles/shell/abc.txt
echo "${fullfile#*.}"
echo "${fullfile%.*}"
