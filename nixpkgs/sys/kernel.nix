{ config, pkgs, lib, ... }:

{

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_6_6;
  };

  # @todo 加入的 vfio 参考 https://gist.github.com/CRTified/43b7ce84cd238673f7f24652c85980b3 不过他的感觉也是瞎写的
  boot.kernelModules = [ "vfio_pci" "vfio_iommu_type1"
    "vmd" "null_blk" "scsi_debug" "vhost_net" ];
  boot.initrd.kernelModules = [];
  boot.blacklistedKernelModules = [ "nouveau" ];

  boot.extraModprobeConfig = ''
  options scsi_debug dev_size_mb=100
'';

  boot.kernelParams = [
    "transparent_hugepage=never"
    "mitigations=off"
    # 硬件上都直接不支持了
    # "tsx=on"
    # "tsx_async_abort=off"

    # intel_iommu 需要手动打开
    # 不信请看 zcat /proc/config.gz | grep CONFIG_INTEL_IOMMU_DEFAULT_ON
    "intel_iommu=on"
    "iommu=pt"
    "intremap=on"
    # "amd_iommu_intr=vapic"
    # "kvm-amd.avic=1"
    # "isolcpus=28-31"
    # "amd_iommu_intr=legacy"
    # "ftrace=function"
    # "ftrace_filter=amd_iommu_int_thread"

    # "processor.max_cstate=1"
    # "intel_idle.max_cstate=0"
    # "amd_iommu=off"
    # "amd_iommu=pgtbl_v2"
    # "iommu=pt"
    # 手动禁用 avx2
    # "clearcpuid=156"

    # @todo 不是 systemd 会默认启动 fsck 的吗，这个需要啥
    # "fsck.mode=force"
    "fsck.repair=yes"
    "ftrace=function"
    "ftrace_filter=dmar_set_interrupt"
  ];

boot.kernelPatches = [
  {
    name = "tracing";
    patch = null;
    extraStructuredConfig = {
      BOOTTIME_TRACING = lib.kernel.yes;
    };
  }

  {
    name = "damon";
    patch = null;
    extraStructuredConfig = {
      DAMON=lib.kernel.yes;
      DAMON_VADDR=lib.kernel.yes;
      DAMON_PADDR=lib.kernel.yes;
      DAMON_SYSFS=lib.kernel.yes;
      DAMON_RECLAIM=lib.kernel.yes;
      DAMON_LRU_SORT=lib.kernel.yes;
    };
  }

  {
    name = "lru_gen";
    patch = null;
    extraStructuredConfig = {
      LRU_GEN_STATS=lib.kernel.yes;
    };
  }

  {
    name = "zswap";
    patch = null;
    extraStructuredConfig = {
      ZSWAP_DEFAULT_ON=lib.kernel.yes;
    };
  }

  {
    name = "irq";
    patch = null;
    extraStructuredConfig = {
      GENERIC_IRQ_DEBUGFS=lib.kernel.yes;
    };
  }

  {
    name = "iommu";
    patch = null;
    extraStructuredConfig = {
      IOMMU_DEBUGFS=lib.kernel.yes;
      AMD_IOMMU_DEBUGFS=lib.kernel.yes;
      INTEL_IOMMU_DEBUGFS=lib.kernel.yes;
    };
  }

  {
    name = "watchdog";
    patch = null;
    extraStructuredConfig = {
      LOCKUP_DETECTOR=lib.kernel.yes;
      SOFTLOCKUP_DETECTOR=lib.kernel.yes;
      HARDLOCKUP_DETECTOR_PERF=lib.kernel.yes;
      HARDLOCKUP_CHECK_TIMESTAMP=lib.kernel.yes;
      HARDLOCKUP_DETECTOR=lib.kernel.yes;
    };
  }


  # 增加一个 patch 的方法
  /*
  {
    name = "amd-iommu";
    # https://www.reddit.com/r/NixOS/comments/oolk59/how_do_i_apply_local_patches_to_the_kernel/
    # 这里不要携带双引号
    patch = /home/martins3/.dotfiles/nixpkgs/patches/amd_iommu.patch;
  }

  {
    name = "dma-ops";
    patch = /home/martins3/.dotfiles/nixpkgs/patches/dma_ops.patch;
  }
  */
  ];
}
