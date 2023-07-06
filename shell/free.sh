#!/usr/bin/env bash

set -E -e -u -o pipefail

fff=fa

[[ "fafafa" =~ ^$fff ]] && echo "1"
[[ "fafafa" =~ "^$fff" ]] && echo "2"
[[ "fafafa" == "$fff" ]] && echo "3"
[[ "fafafa" == $fff ]] && echo "4"
[[ "fafafa" =~ "$fff" ]] && echo "5"
