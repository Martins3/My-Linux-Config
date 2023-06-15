#!/usr/bin/env bash

set -E -e -u -o pipefail

fff=fa

if [[ "fafafa" =~ "$fff" ]];then
  echo "good"
fi
