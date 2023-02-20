#!/usr/bin/env bash
set -ex
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/run/current-system/sw/bin/"
function finish {
  if [[ $? == 0 ]]; then
    sleep 600
    exit 0
  fi
  sleep infinity
}

trap finish EXIT

if cd /home/martins3/core/linux; then
  echo "kernel already setup"
else
  mkdir -p /home/martins3/core/
  cd /home/martins3/core
  git clone https://github.com/torvalds/linux
  cd linux
fi

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
fi

# 内核为了编译速度，使用 #include 直接包含 .c 文件，
# 将这些文件展开，从而可以正确跳转
git restore --staged kernel/sched/build_utility.c
git restore --staged kernel/sched/build_policy.c
git checkout -- kernel/sched/build_utility.c
git checkout -- kernel/sched/build_policy.c

git pull

python3 /home/martins3/.dotfiles/scripts/systemd/revert-build-fast.py
git add kernel/sched/build_utility.c
git add kernel/sched/build_policy.c

cat <<_EOF_ >kernel/configs/martins3.config
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_DWARF5=y
CONFIG_GDB_SCRIPTS=y

# centos 需要
CONFIG_XFS_FS=y

CONFIG_MEMCG=y
CONFIG_BPF_SYSCALL=y

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

# sshfs 需要
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

# 分析 transparent huge page
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set

# 分析 damon
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_DAMON=y
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
CONFIG_DAMON_SYSFS=y
CONFIG_DAMON_DBGFS=y
CONFIG_DAMON_RECLAIM=y
CONFIG_DAMON_LRU_SORT=y

# 分析 userfault fd
CONFIG_USERFAULTFD=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_PTE_MARKER=y
CONFIG_PTE_MARKER_UFFD_WP=y

CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGE_REPORTING=y
CONFIG_CONTIG_ALLOC=y
CONFIG_KSM=y
# cma
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_CMA_DEBUGFS=y
CONFIG_CMA_SYSFS=y
CONFIG_CMA_AREAS=19
CONFIG_IDLE_PAGE_TRACKING=y
# CONFIG_DMA_CMA is not set

# balloon
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_VIRTIO_BALLOON=y

# hotplug / virtio-mem / virtio-pmem
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_VIRTIO_PMEM=y
CONFIG_VIRTIO_MEM=y
CONFIG_LIBNVDIMM=y
CONFIG_BLK_DEV_PMEM=y
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=y
CONFIG_BTT=y
CONFIG_DAX=y
# CONFIG_DEV_DAX is not set
CONFIG_MEMREGION=y

CONFIG_ACPI_HOTPLUG_MEMORY=y

# CONFIG_BLK_CGROUP_FC_APPID is not set
CONFIG_NVME_COMMON=y
CONFIG_NVME_CORE=y
CONFIG_BLK_DEV_NVME=y
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_VERBOSE_ERRORS=y
CONFIG_NVME_HWMON=y
CONFIG_NVME_FABRICS=y
CONFIG_NVME_FC=y
CONFIG_NVME_TCP=y
CONFIG_NVME_AUTH=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y

# CONFIG_ACPI_IPMI is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set

# IOMMU
CONFIG_ACPI_VIOT=y
CONFIG_IRQ_REMAP=y
CONFIG_VIRTIO_IOMMU=y

# scheduler 相关
CONFIG_SCHED_CORE=y
CONFIG_UCLAMP_TASK=y
CONFIG_UCLAMP_BUCKETS_COUNT=5
CONFIG_SCHED_AUTOGROUP=y

# cgroup 相关内容
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_UCLAMP_TASK_GROUP=y

CONFIG_INTEL_IDLE=y

CONFIG_ZPOOL=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC=y
CONFIG_ZSWAP_ZPOOL_DEFAULT="zsmalloc"
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
CONFIG_ZBUD=y
CONFIG_FRONTSWAP=y
# CONFIG_ZRAM is not set
CONFIG_CRYPTO_LZO=y
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=y

CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y

CONFIG_NET_UDP_TUNNEL=y
CONFIG_BONDING=y
CONFIG_DUMMY=y

CONFIG_WIREGUARD=y
# CONFIG_WIREGUARD_DEBUG is not set
CONFIG_TUN=y
# CONFIG_BIG_KEYS is not set
CONFIG_CRYPTO_CURVE25519_X86=y
CONFIG_CRYPTO_BLAKE2S_X86=y
CONFIG_CRYPTO_POLY1305_X86_64=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
CONFIG_CRYPTO_LIB_CURVE25519=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y

# soft lockup / hard lockup
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_HARDLOCKUP_DETECTOR_PERF=y

CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y

CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y

# try to learn scsi
CONFIG_SCSI_LOGGING=y

CONFIG_BLK_DEV_UBLK=y

# --- fault inejction -------------------------
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAULT_INJECTION_USERCOPY=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_FUTEX=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y

CONFIG_FAIL_FUNCTION=y
# --------------------------------------------

CONFIG_BPF_KPROBE_OVERRIDE=y

# ----- iscsi targetcli 需要 begin ------
# 1. configfs
# 2. target_core
# 3. iscsi_target
CONFIG_CONFIGFS_FS=y

CONFIG_TARGET_CORE=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRC_T10DIF=y

CONFIG_ISCSI_TARGET=y
CONFIG_CRYPTO_CRC32C_INTEL=y

CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_CRYPTO_CRC64_ROCKSOFT=y
CONFIG_CRC64_ROCKSOFT=y
CONFIG_CRC64=y

CONFIG_BLK_DEV_BSGLIB=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_ISCSI_TCP=y
# ----- iscsi targetcli 需要 end ------

# 增加一个专门用于调试的 scsi 设备
CONFIG_SCSI_DEBUG=y

# 支持 cgroup 中 io.max
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_DEV_THROTTLING_LOW=y
# CONFIG_BLK_WBT=y
# CONFIG_BLK_WBT_MQ=y

# 网络模拟
CONFIG_NET_SCH_NETEM=y

CONFIG_PSI=y
# CONFIG_PSI_DEFAULT_DISABLED is not set

# CONFIG_DRM_I915_GVT_KVMGT is not set
CONFIG_VFIO=y
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=y
# CONFIG_VFIO_NOIOMMU is not set
CONFIG_VFIO_VIRQFD=y
CONFIG_VFIO_PCI_CORE=y
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=y
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_IGD=y
CONFIG_VFIO_MDEV=y

# @todo 如何使用
CONFIG_PARAVIRT_DEBUG=y
# @todo 原理
CONFIG_PARAVIRT_SPINLOCKS=y
# @todo 原理
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# @todo 尝试使用下
CONFIG_JAILHOUSE_GUEST=y
# @todo 尝试使用下
CONFIG_ACRN_GUEST=y

CONFIG_MODVERSIONS=y
CONFIG_ASM_MODVERSIONS=y

# @todo 这里有好几个选项都是看不懂的哇
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
CONFIG_LLC=y

# @todo 为什么 ovs 会自动打开这几个选项
CONFIG_NF_NAT_OVS=y
CONFIG_OPENVSWITCH=y
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_MPLS_ROUTING is not set
CONFIG_NET_NSH=y


# https://virtio-fs.gitlab.io/howto-qemu.html
# 为了支持 virtiofs 共享目录
CONFIG_VIRTIO_FS=y

# @todo zone device 到底是什么？为什么和 DAX 有关
CONFIG_DEVICE_MIGRATION=y
CONFIG_ZONE_DEVICE=y
# CONFIG_DEVICE_PRIVATE is not set
# CONFIG_PCI_P2PDMA is not set
CONFIG_ND_PFN=y
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y

# @todo fs 为什么可以用来 DAX
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FUSE_DAX=y

_EOF_

RECORD_TIME=true

nix-shell --command "make defconfig kvm_guest.config martins3.config"
if [[ $RECORD_TIME == true ]]; then
  nix-shell --command "make clean"
  SECONDS=0
fi
nix-shell --command "make -j$(($(getconf _NPROCESSORS_ONLN) - 1))"

if [[ $RECORD_TIME == true ]]; then
  duration=$SECONDS
  echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
  echo "$(date) : $duration : " >>/home/martins3/core/compile-linux/database
  cat /proc/cmdline >>/home/martins3/core/compile-linux/database
fi

# 编译的速度太慢了，不想每次都等那么久
if [[ ! -d /home/martins3/core/linux/Documentation/output ]]; then
  nix-shell --command "make htmldocs -j$(($(getconf _NPROCESSORS_ONLN) - 1))"
fi
# nix-shell --command "rm -r .cache"
nix-shell --command "./scripts/clang-tools/gen_compile_commands.py"
# nix-shell --command "make binrpm-pkg -j$(($(getconf _NPROCESSORS_ONLN) - 1))"
#
# Documentation/conf.py 中修改主题 html_theme = 'sphinx_rtd_theme'

# 1. 启动虚拟机，让 Guest 安装对应的内核
# 2. nixos 中无法成功运行 make -C tools/testing/selftests TARGETS=vm run_testsq
# 3. 应该关注 linux-next 分支 : https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

# @todo 等 ccls 的 bug 被修复再说吧
nvim "+let g:auto_session_enabled = v:false" -c ":e mm/gup.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 30, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"
