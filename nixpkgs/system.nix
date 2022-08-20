# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

let
  # mkpasswd -m sha-512
  passwd = "$6$Iehu.x9i7eiceV.q$X4INuNrrxGvdK546sxdt3IV9yHr90/Mxo7wuIzdowoN..jFSFjX8gHaXchfBxV4pOYM4h38pPJOeuI1X/5fon/";
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
    libcgroup # taskset cgcreate
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

  # 目录折叠之后，和大多数教材样子都不同了
  systemd.enableUnifiedCgroupHierarchy = false;

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

  documentation.dev.enable = true;

  systemd.services.kernel = {
    enable = true;
    description = "synchronize kernel every day";
    unitConfig = { };
    serviceConfig = {
      User = "martins3";
      WorkingDirectory = "/home/martins3/core/linux";
      Type = "forking";
      # RemainAfterExit = true;
      ExecStart = "/home/martins3/.nix-profile/bin/tmux new-session -d -s ccls '/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/sync-kernel.sh'";
      Restart = "no";
    };
  };

  systemd.timers.kernel = {
    enable = true;
    timerConfig = { OnCalendar = "*-*-* 9:00:00"; };
    wantedBy = [ "timers.target" ];
  };
}
