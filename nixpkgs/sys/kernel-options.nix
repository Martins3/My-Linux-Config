{ config, pkgs, lib, ... }:

{

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_6_7;
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
}
