{ config, pkgs, ... }:

{

  boot.kernel.sysctl = {
    # "vm.swappiness" = 200;
    "vm.overcommit_memory" = 1;
    "kernel.dmesg_restrict" = 0;
  };

  # https://nixos.org/manual/nixos/stable/index.html#ch-file-systems
  # 这一个例子如何自动 mount 一个盘，但是配置放到 /etc/nixos/configuration.nix
  # 中，参考[1] 但是 options 只有包含一个
  # [1]: https://unix.stackexchange.com/questions/533265/how-to-mount-internal-drives-as-a-normal-user-in-nixos
  #
  #  fileSystems."/home/martins3/hack" = {
  #    device = "/dev/disk/by-uuid/b709d158-aa6a-4b72-8255-513517548111";
  #    fsType = "auto";
  #    options = [ "user" "exec" "nofail"];
  #  };

  systemd.services.iscsid = {
    enable = true;
  };

  # TODO 这个方法好笨
  systemd.services.hugepage = {
    enable = true;
    description = "make user process access hugepage";
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/chmod o+w /dev/hugepages/";
      Restart = "no";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.user.services.kernel_doc = {
    enable = true;
    description = "export kernel doc at 127.0.0.1:3434";
    serviceConfig = {
      WorkingDirectory = "/home/martins3/core/linux/Documentation/output";
      Type = "simple";
      ExecStart = "/home/martins3/.nix-profile/bin/python -m http.server 3434";
      Restart = "no";
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.user.services.pueued = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      ExecStart = "${pkgs.pueue.outPath}/bin/pueued -vv";
      Restart = "no";
    };
    wantedBy = [ "default.target" ];
  };

  # virtualisation.vmware.host.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "10.11.0.1/16";
  };
  virtualisation.podman.enable = true;
  virtualisation.vswitch.enable = true;
  virtualisation.vswitch.package = pkgs.openvswitch;
  # services.fstrim.enable = true;
  virtualisation.libvirtd.enable = true;

  # zramSwap.enable = true;

}
