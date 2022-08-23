#!/usr/bin/env bash
set -ex
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/run/current-system/sw/bin/"
function finish {
  sleep infinity
}
trap finish EXIT

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
fi

git pull

cat <<_EOF_ >kernel/configs/martins3.config
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y

# centos 需要
CONFIG_XFS_FS=y

CONFIG_MEMCG=y # TODO
CONFIG_BPF_SYSCALL=y # TODO

CONFIG_GUEST_PERF_EVENTS=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_KVM_XEN is not set
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_IRQ_BYPASS_MANAGER=y

# # fedora 需要
# CONFIG_BTRFS_FS=y
# # CONFIG_BTRFS_FS_POSIX_ACL is not set
# # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# # CONFIG_BTRFS_DEBUG is not set
# # CONFIG_BTRFS_ASSERT is not set
# # CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_XOR_BLOCKS=y
# CONFIG_CRYPTO_XXHASH=y
# CONFIG_CRYPTO_BLAKE2B=y
# CONFIG_RAID6_PQ=y
# CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_ZSTD_COMPRESS=y

# sshfs
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
# CONFIG_VIRTIO_FS is not set

_EOF_

nix-shell --command "make defconfig kvm_guest.config martins3.config"
nix-shell --command "make -j32"
./scripts/clang-tools/gen_compile_commands.py

# nvim "+let g:auto_session_enabled = v:false" -c ":e mm/gup.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 60, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"
