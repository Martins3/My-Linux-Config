#!/usr/bin/env bash

set -E -e -u -o pipefail

source=/home/martins3/core/linux/arch/x86/kvm/mmu/mmu.c
header=/home/martins3/core/linux/arch/x86/kvm/mmu/paging_tmpl.h

sed -i "s/#include \"paging_tmpl.h\"//" $source
sed -i -e "/#define PTTYPE PTTYPE_EPT/r $header" $source

# 有趣，这些代码实际上不能注销掉，否则系统无法启动，
# 说明，内核的模式实际上发生过切换
functions=(
  paging32_page_fault
  paging32_gva_to_gpa
  paging32_sync_page
  paging32_invlpg

  paging64_page_fault
  paging64_gva_to_gpa
  paging64_sync_page
  paging64_invlpg
)

for i in "${functions[@]}"; do
  sed -i -e "/$i/s/^/ {\/*/" $source
  sed -i -e "/$i/s/\$/*\/}/" $source
done
