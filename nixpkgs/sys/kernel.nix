{ config, pkgs, lib, ... }:

{

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  boot.kernelParams = [
    "transparent_hugepage=always"
    # https://gist.github.com/rizalp/ff74fd9ededb076e6102fc0b636bd52b
    # 十次测量编译内核，打开和不打开的性能差别为 : 131.1  143.4
    # 性能提升 9.38%
    # "noibpb"
    # "nopti"
    # "nospectre_v2"
    # "nospectre_v1"
    # "l1tf=off"
    # "nospec_store_bypass_disable"
    # "no_stf_barrier"
    # "mds=off"
    # "mitigations=off"
    # 硬件上都直接不支持了
    # "tsx=on"
    # "tsx_async_abort=off"

    # vfio 直通
    # "intel_iommu=on"
    # "intremap=on"
    # "iommu=pt"
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
    name = "lru";
    patch = null;
    extraStructuredConfig = {
      LRU_GEN=lib.kernel.yes;
      LRU_GEN_ENABLED=lib.kernel.yes;
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

  # 增加一个 patch 的方法
  /*
  {
    name = "amd-iommu";
    # https://www.reddit.com/r/NixOS/comments/oolk59/how_do_i_apply_local_patches_to_the_kernel/
    # 这里不要携带双引号
    patch = /home/martins3/.dotfiles/nixpkgs/patches/amd_iommu.patch;
  }
  */
  ];
}
