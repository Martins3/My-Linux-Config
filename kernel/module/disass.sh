#!/usr/bin/env bash
set -E -e -u -o pipefail

make -j32
gdb -quiet access-once.o -ex "disass test$1" -ex "q"
