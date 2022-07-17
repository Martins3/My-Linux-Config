# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

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
  ];

  users.mutableUsers = false;
  # mkpasswd -m sha-512
  users.users.root.hashedPassword = "$6$xJlhvb6Y83BiCZXi$SKNZ5oC4gudBJEwGr9YZvaWnQxwGik/saFmJb4IoRwJx2mH9gOCtVJhR16xbd.EgzrLdESwv03/01dMsyBxtf.";
  users.users.martins3 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    home = "/home/martins3";
    # TMP_TODO 补充文档
    # https://stackoverflow.com/questions/51342810/how-to-fix-dial-unix-var-run-docker-sock-connect-permission-denied-when-gro
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    hashedPassword = "$6$xJlhvb6Y83BiCZXi$SKNZ5oC4gudBJEwGr9YZvaWnQxwGik/saFmJb4IoRwJx2mH9gOCtVJhR16xbd.EgzrLdESwv03/01dMsyBxtf.";
  };
}
