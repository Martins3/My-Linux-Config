#!/usr/bin/env bash
# @todo 不知道为什么，是不可以使用 #!/usr/bin/env bash，会被报错的
# 如果使用 bash 启动之后, nix-shell 还是需要如此写
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
set -ex
function finish {
  sleep infinity
}
trap finish EXIT
nix="/run/current-system/sw/bin/nix-shell"

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
fi

cat <<_EOF_ >kernel/configs/martins3.config
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y

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

# TMP_TODO 将 GPU 的驱动关掉

_EOF_

$nix --command "make defconfig kvm_guest.config martins3.config"
$nix --command "make -j32"
./scripts/clang-tools/gen_compile_commands.py

# @todo 还是因为环境变量的问题，这里的操作有问题
# $nix --command 'nvim "+let g:auto_session_enabled = v:false" -c ":e mm/gup.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 60, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"'
