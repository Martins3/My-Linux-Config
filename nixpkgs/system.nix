# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

let
  # mkpasswd -m sha-512
  passwd = "$6$Iehu.x9i7eiceV.q$X4INuNrrxGvdK546sxdt3IV9yHr90/Mxo7wuIzdowoN..jFSFjX8gHaXchfBxV4pOYM4h38pPJOeuI1X/5fon/";

  unstable = import <unstable> { };
in
{
  imports = [
    ./sys/cli.nix
  ] ++ (if (builtins.getEnv "DISPLAY") != ""
  then [
    ./sys/gui.nix
  ] else [ ]);

  nix.binaryCaches = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  # https://nixos.wiki/wiki/Virt-manager
  virtualisation.libvirtd = {
    enable = true;
    # https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/virtualization_host_configuration_and_guest_installation_guide/app_tcp_ports
    extraConfig = "
    listen_tls = 1
    listen_tcp = 1
    listen_addr = \"0.0.0.0\"
    ";
    extraOptions = [ "LIBVIRTD_ARGS=\"--listen\"" ];
  };

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    vim
    git
    wget
    zsh
    unstable.libcgroup # taskset cgcreate
  ];

  users.mutableUsers = false;
  users.users.root.hashedPassword = passwd;
  users.users.martins3 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    home = "/home/martins3";
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    hashedPassword = passwd;
  };

  boot.crashDump.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # systemd.enableUnifiedCgroupHierarchy = false; # cgroup v1
  systemd.enableUnifiedCgroupHierarchy = true; # cgroup v2

  # nixos 的 /tmp 不是 tmpfs 的，但是我希望重启之后，/tmp 被清空
  boot.cleanTmpDir = true;

  services.syncthing = {
    enable = true;
    systemService = true;
    # relay.enable = true;
    user = "martins3";
    dataDir = "/home/martins3";
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "0.0.0.0:8384";
  };

  documentation.enable = true;

  services.earlyoom = {
    enable = true;
  };

  services.jenkins = {
    enable = true;
  };

  systemd.user.services.kernel = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      # User = "martins3";
      WorkingDirectory = "/home/martins3/core/linux";
      Type = "forking";
      # RemainAfterExit = true;
      ExecStart = "/home/martins3/.nix-profile/bin/tmux new-session -d -s kernel '/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/sync-kernel.sh'";
      Restart = "no";
    };
  };

  # systemctl --user list-timers --all
  systemd.user.timers.kernel = {
    enable = true;
    timerConfig = { OnCalendar = "*-*-* 4:00:00"; };
    wantedBy = [ "timers.target" ];
  };

  systemd.user.services.qemu = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      WorkingDirectory = "/home/martins3/core/qemu";
      Type = "forking";
      ExecStart = "/home/martins3/.nix-profile/bin/tmux new-session -d -s qemu '/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/sync-qemu.sh'";
      Restart = "no";
    };
  };

  systemd.user.timers.qemu = {
    enable = true;
    timerConfig = { OnCalendar = "*-*-* 4:30:00"; };
    wantedBy = [ "timers.target" ];
  };

  systemd.user.services.httpd = {
    enable = true;
    description = "export home dir to LAN";
    serviceConfig = {
      WorkingDirectory = "/home/martins3/";
      Type = "simple";
      ExecStart = "/home/martins3/.nix-profile/bin/python -m http.server";
      Restart = "no";
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services.iscsid = {
    enable = true;
  };
  nix.settings.experimental-features = "nix-command flakes";
}
