{ config, pkgs, lib, ... }:

{
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_4_19;
  };

  /*
     boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_4_19.override {
     argsOverride = rec {
     src = pkgs.fetchurl {
     url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
     sha256 = "0c9xxqgv2i36hrr06dwz7f3idc04xpv0a5pxg08xdh03cnyf12cx";
     };
     version = "4.19.297";
     modDirVersion = "4.19.297";
     };
     });
   */

  boot.kernelParams = [
    "mitigations=off"
    "iommu=nopt"
  ];

}
