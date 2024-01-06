#!/usr/bin/env bash
set -E -e -u -o pipefail

if cat /home/martins3/kernel/centos-3.10.0-1160.11.1-x86_64/drivers/scsi/scsi_lib.c | grep -q Copyright ; then
  echo "found"
else
  echo "not found"
fi
