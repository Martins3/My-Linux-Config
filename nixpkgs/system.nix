# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

let
  # mkpasswd -m sha-512
  passwd = "$6$Iehu.x9i7eiceV.q$X4INuNrrxGvdK546sxdt3IV9yHr90/Mxo7wuIzdowoN..jFSFjX8gHaXchfBxV4pOYM4h38pPJOeuI1X/5fon/";
in
{
  # TMP_TODO i think there's no need to include gui.nix
  # 非常神奇，如果含有 gui.nix 之后，那么就会 UI 界面
  imports = [
    ./sys/cli.nix
    /* ./sys/gui.nix */
  ];

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

  # TMP_TODO 但是还是需要手动 sudo systemctl start libvirtd, 是因为需要重启的，如果启用你新的 service
  programs.dconf.enable = true;
  # TMP_TODO 如果出现重复会有什么问题吗？和 /etc/nixos/configuration.nix 中的
  environment.systemPackages = with pkgs; [
    virt-manager
    vim
    git
    wget
    zsh
    # To make SMB mounting easier on the command line
    # TMP_TODO 这个工具的功能是啥来着
    cifs-utils
  ];

  users.mutableUsers = false;
  users.users.root.hashedPassword = passwd;
  users.users.martins3 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    home = "/home/martins3";
    # TMP_TODO 补充文档
    # https://stackoverflow.com/questions/51342810/how-to-fix-dial-unix-var-run-docker-sock-connect-permission-denied-when-gro
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    hashedPassword = passwd;
  };

  boot.crashDump.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6
  services.samba = {
    enable = true;

    /* syncPasswordsByPam = true; */
    # You will still need to set up the user accounts to begin with:
    # TMP_TODO 在文档中描述一下，是需要密码的
    # $ sudo smbpasswd -a yourusername

    # This adds to the [global] section:
    extraConfig = ''
      browseable = yes
      # smb encrypt = required
      # suggestions here:
      # https://superuser.com/questions/713248/home-file-server-using-samba-has-slow-read-and-write-speed
      read raw = Yes
      write raw = Yes
      socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072
      min receivefile size = 16384
      use sendfile = true
      aio read size = 16384
      aio write size = 16384
    '';

    shares = {
      homes = {
        browseable = "no";  # note: each home will be browseable; the "homes" share will not.
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };

  # Curiously, `services.samba` does not automatically open
  # the needed ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 445 139 ];
  # networking.firewall.allowedUDPPorts = [ 137 138 ];
  services.syncthing = {
    enable = true;
    systemService = true;
    # TMP_TODO 这个选项是做啥的
    # relay.enable = true;
    user = "martins3";
    dataDir = "/home/martins3";
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "0.0.0.0:8384";
  };

}
