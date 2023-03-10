# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

let
  # mkpasswd -m sha-512
  passwd = "$6$Iehu.x9i7eiceV.q$X4INuNrrxGvdK546sxdt3IV9yHr90/Mxo7wuIzdowoN..jFSFjX8gHaXchfBxV4pOYM4h38pPJOeuI1X/5fon/";

  unstable = import <nixos-unstable> { };
in
{
  imports = [
    ./sys/cli.nix
  ] ++ (if (builtins.getEnv "DISPLAY") != ""
  then [
    ./sys/gui.nix
  ] else [ ]);

  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;

  # nvidia GPU card configuration, for details,
  # see https://nixos.wiki/wiki/Nvidia
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.opengl.enable = true;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.vswitch.enable = true;

  networking.proxy.default = "http://127.0.0.1:8889";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # virt manager 是一个图形化的 virsh ，用于创建和管理虚拟机
  # @todo virt-manager 有意义吗？
  # https://nixos.wiki/wiki/Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virtmanager
    vim
    git
    wget
    zsh
    unstable.nushell
    unstable.tailscale
    cifs-utils
  ];
  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $(cat /home/martins3/.tailscale-credentials)
    '';
  };

  networking.firewall.checkReversePath = "loose";

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [
      22 # ssh
      5201 # iperf
      8889 # clash
      8384 # syncthing
      22000 # syncthing
    ];
  };

  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # @todo ----- 将这块代码移动到设备专用的地方去 -------
  # @todo 如何处理总是等待 /sys/subsystem/net/devices/enp4s0 的问题
  # 我靠，不知道什么时候 enp4s0 不见了，systemd 真的复杂啊
  # tailscale0 建立的网卡是什么原理，真有趣啊
  # networking.interfaces.enp4s0.useDHCP = false;
  networking.bridges.br0.interfaces = [ "enp5s0" ];
  # sudo ip ad add 10.0.0.1/24 dev enp5s0

  # @todo 这个配置为什么不行
  /* networking.interfaces.enp5s0.ipv4.addresses = [{ */
  /*   address = "10.0.0.1"; */
  /*   prefixLength = 24; */
  /* }]; */

  # wireless and wired coexist
  # @todo disable this temporarily
  systemd.network.wait-online.timeout = 0;

  users.mutableUsers = false;
  users.users.root.hashedPassword = passwd;
  users.users.martins3 = {
    isNormalUser = true;
    # shell = pkgs.zsh;
    shell = pkgs.nushell;
    home = "/home/martins3";
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    hashedPassword = passwd;
  };

  boot = {
    crashDump.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    # nixos 的 /tmp 不是 tmpfs 的，但是我希望重启之后，/tmp 被清空
    cleanTmpDir = true;
  };

  boot.kernelParams = [
    # "transparent_hugepage=always"
    "transparent_hugepage=never"
    # https://gist.github.com/rizalp/ff74fd9ededb076e6102fc0b636bd52b
    /* "noibpb" */
    /* "nopti" */
    /* "nospectre_v2" */
    /* "nospectre_v1" */
    /* "l1tf=off" */
    /* "nospec_store_bypass_disable" */
    /* "no_stf_barrier" */
    /* "mds=off" */
    /* "tsx=on" */
    /* "tsx_async_abort=off" */
    /* "mitigations=off" */

    "intel_iommu=on"
    "iommu=pt"
  ];


  boot.supportedFilesystems = [ "ntfs" ];

  # GPU passthrough with vfio need memlock
  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "infinity"; }
  ];

  /* /dev/nvme1n2p3: BLOCK_SIZE="512" UUID="0470864A70864302" TYPE="ntfs" PARTUUID="8402854e-03" */
  /* /dev/nvme1n2p1: LABEL="M-gM-3M-;M-gM-;M-^_M-dM-?M-^]M-gM-^UM-^Y" BLOCK_SIZE="512" UUID="409E41739E416310" TYPE="ntfs" PARTUUID="8402854e-01" */
  /* /dev/nvme1n2p2: BLOCK_SIZE="512" UUID="02084242084234C7" TYPE="ntfs" PARTUUID="8402854e-02" */

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # https://www.reddit.com/r/NixOS/comments/wjskae/how_can_i_change_grub_theme_from_the/
      # theme = pkgs.nixos-grub2-theme;
      theme =
        pkgs.fetchFromGitHub {
          owner = "shvchk";
          repo = "fallout-grub-theme";
          rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
          sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
        };
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;

      # useOSProber = true; # 没有说的那么不堪，还是很好用的

      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      # /dev/nvme1n1p1: BLOCK_SIZE="512" UUID="3A22AF3A22AEF9D1" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="1b23d1fb-c1ad-4b8b-83e1-79005771a027"
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          search --fs-uuid --set=root 4957-45A0
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };


  services.openssh.enable = true;

  # 默认是 cgroup v2
  # systemd.enableUnifiedCgroupHierarchy = false; # cgroup v1

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

  # earlyoom 检查方法 sudo journalctl -u earlyoom | grep sending
  # @todo services 和 systemd 的差别是什么?
  systemd.oomd = {
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
      Type = "forking";
      # RemainAfterExit = true;
      ExecStart = "/home/martins3/.nix-profile/bin/tmux new-session -d -s kernel '/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/sync-kernel.sh'";
      Restart = "no";
    };
  };

  # systemctl --user list-timers --all
  systemd.user.timers.kernel = {
    enable = false;
    timerConfig = { OnCalendar = "*-*-* 4:00:00"; };
    wantedBy = [ "timers.target" ];
  };

  systemd.user.services.qemu = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      Type = "forking";
      ExecStart = "/home/martins3/.nix-profile/bin/tmux new-session -d -s qemu '/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/sync-qemu.sh'";
      Restart = "no";
    };
  };

  systemd.user.timers.qemu = {
    enable = false;
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

  # @todo 使用下吧
  systemd.services.iscsid = {
    enable = true;
  };
  nix.settings.experimental-features = "nix-command flakes";
  # 因为使用的最新内核，打开这个会导致更新过于频繁
  system.autoUpgrade.enable = false;

  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;

  # 参考 https://gist.github.com/CRTified/43b7ce84cd238673f7f24652c85980b3
  boot.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio" ];
  # @todo 是因为打开了 vfio_virqfd 才导致中断直接进入到内核态中解决的吗?
  # @todo vfio_virqfd 在让 6.2 内核无法正常编译了，为什么
  boot.initrd.kernelModules = ["vfio_pci" "vfio_iommu_type1" "vfio" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # services.telegraf.enable = true;
  # services.influxdb2.enable = true;
  # services.grafana = {
  #   enable = true;
  #   # Grafana needs to know on which domain and URL it's running:
  #   settings.server = {
  #     domain = "martins3.domain";
  #     http_addr = "127.0.0.1";
  #     port = 3000;
  #   };
  # };
  # services.victoriametrics.enable = true;


  services.samba = {
    enable = true;

    /* syncPasswordsByPam = true; */

    # This adds to the [global] section:
    extraConfig = ''
      browseable = yes
      smb encrypt = required
    '';

    shares = {
      public = {
        path = "/home/martins3/core/winshare";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        /* "create mask" = "0644"; */
        /* "directory mask" = "0755"; */
        /* "force user" = "username"; */
        /* "force group" = "groupname"; */
      };
    };
  };
}
