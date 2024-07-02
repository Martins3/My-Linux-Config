{ config, pkgs, lib, ... }:

{

# 使用的语法参考:
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/kernel.nix
# TODO 这里存在让 fio nullblk 性能下降 10% 的选项，有趣啊
boot.kernelPatches = [
  # {
  #   name = "tracing";
  #   patch = null;
  #   extraStructuredConfig = {
  #     BOOTTIME_TRACING = lib.kernel.yes;
  #     IRQSOFF_TRACER = lib.kernel.yes;
  #     MMIOTRACE = lib.kernel.yes;
  #     OSNOISE_TRACER = lib.kernel.yes;
  #     FPROBE = lib.kernel.yes;
  #     TIMERLAT_TRACER = lib.kernel.yes;
  #     PREEMPT_TRACER = lib.kernel.yes;
  #     HWLAT_TRACER = lib.kernel.yes;
  #   };
  # }

  # {
  #   name = "damon";
  #   patch = null;
  #   extraStructuredConfig = {
  #     DAMON=lib.kernel.yes;
  #     DAMON_VADDR=lib.kernel.yes;
  #     DAMON_PADDR=lib.kernel.yes;
  #     DAMON_SYSFS=lib.kernel.yes;
  #     DAMON_RECLAIM=lib.kernel.yes;
  #     DAMON_LRU_SORT=lib.kernel.yes;
  #   };
  # }

  # {
  #   name = "hwpoison";
  #   patch = null;
  #   extraStructuredConfig = {
  #     MEMORY_FAILURE=lib.kernel.yes;
  #     HWPOISON_INJECT=lib.kernel.yes;
  #   };
  # }

  # {
  #   name = "lru_gen";
  #   patch = null;
  #   extraStructuredConfig = {
  #     LRU_GEN_STATS=lib.kernel.yes;
  #   };
  # }

  # {
  #   name = "zswap";
  #   patch = null;
  #   extraStructuredConfig = {
  #     ZSWAP_DEFAULT_ON=lib.kernel.yes;
  #   };
  # }

  {
    name = "irq";
    patch = null;
    extraStructuredConfig = {
      GENERIC_IRQ_DEBUGFS=lib.kernel.yes;
    };
  }


  {
    name = "mdev";
    patch = null;
    extraStructuredConfig = {
      SAMPLES=lib.kernel.yes;
      SAMPLE_VFIO_MDEV_MTTY=lib.kernel.module;
      SAMPLE_VFIO_MDEV_MDPY=lib.kernel.module;
      SAMPLE_VFIO_MDEV_MBOCHS=lib.kernel.module;
    };
  }

  # {
  #   name = "iommu";
  #   patch = null;
  #   extraStructuredConfig = {
  #     IOMMU_DEBUGFS=lib.kernel.yes;
  #     AMD_IOMMU_DEBUGFS=lib.kernel.yes;
  #     INTEL_IOMMU_DEBUGFS=lib.kernel.yes;
  #   };
  # }

  # {
  #   name = "watchdog";
  #   patch = null;
  #   extraStructuredConfig = {
  #     LOCKUP_DETECTOR=lib.kernel.yes;
  #     SOFTLOCKUP_DETECTOR=lib.kernel.yes;
  #     HARDLOCKUP_DETECTOR_PERF=lib.kernel.yes;
  #     HARDLOCKUP_CHECK_TIMESTAMP=lib.kernel.yes;
  #     HARDLOCKUP_DETECTOR=lib.kernel.yes;
  #   };
  # }


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
