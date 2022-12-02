#!/usr/bin/env bash

lint-md "docs/**/*" -c .lintmdrc.json --threads

if [[ $? ]]; then
  lint-md -f "docs/**/*" -c .lintmdrc.json --threads
else
  exit 1
fi
