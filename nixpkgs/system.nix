# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, lib, ... }:

let
  # mkpasswd -m sha-512
  passwd = "$6$Iehu.x9i7eiceV.q$X4INuNrrxGvdK546sxdt3IV9yHr90/Mxo7wuIzdowoN..jFSFjX8gHaXchfBxV4pOYM4h38pPJOeuI1X/5fon/";

  unstable = import <nixos-unstable> { };
in
{
  imports = [
    ./sys/cli.nix
    ./sys/gui.nix # @todo 这个需要学习下 nix 语言了
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
  # .beta 可以替换为其他的版本，其中 beta 是最新的
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.vswitch.enable = true;

  # zramSwap.enable = true;

  networking.proxy.default = "http://127.0.0.1:8889";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    zsh
    unstable.tailscale
    cifs-utils
  ];
  services.tailscale.enable = true;
  # http://127.0.0.1:19999/
  # services.netdata.enable = true;

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
      5900 # qemu vnc
      445 # samba
      /* 8384 # syncthing */
      /* 22000 # syncthing */
    ];
  };

  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # @todo ----- 将这块代码移动到设备专用的地方去 -------
  # @todo 如何处理总是等待 /sys/subsystem/net/devices/enp4s0 的问题
  # 我靠，不知道什么时候 enp4s0 不见了，systemd 真的复杂啊
  # tailscale0 建立的网卡是什么原理，真有趣啊
  # networking.interfaces.enp4s0.useDHCP = false;
  # networking.bridges.br0.interfaces = [ "enp5s0" ];
  # sudo ip ad add 10.0.0.1/24 dev enp5s0

  # @todo 这个配置为什么不行
  /* networking.interfaces.enp5s0.ipv4.addresses = [{ */
  /*   address = "10.0.0.1"; */
  /*   prefixLength = 24; */
  /* }]; */

  # wireless and wired coexist
  # @todo disable this temporarily
  systemd.network.wait-online.timeout = 1;

  users.mutableUsers = false;
  users.users.root.hashedPassword = passwd;
  users.users.martins3 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # shell = pkgs.nushell;
    home = "/home/martins3";
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    hashedPassword = passwd;
  };

  boot = {
    crashDump.enable = false; # TODO 这个东西形同虚设，无须浪费表情
    crashDump.reservedMemory = "1G";
    kernelPackages = pkgs.linuxPackages_latest;
    # nixos 的 /tmp 不是 tmpfs 的，但是我希望重启之后，/tmp 被清空
    tmp.cleanOnBoot = true;

    loader = {
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
        devices = [ "nodev" ];
        efiSupport = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };

  boot.kernelParams = [
    # "transparent_hugepage=always"
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
    "intel_iommu=on"
    "intremap=on"
    "iommu=pt"
    "amd_iommu_intr=vapic"
    "kvm-amd.avic=1"
    # "amd_iommu_intr=legacy"
    "ftrace=function"
    "ftrace_filter=amd_iommu_int_thread"

    # "processor.max_cstate=1"
    # "intel_idle.max_cstate=0"
    # "amd_iommu=off"
    # "amd_iommu=pgtbl_v2"
    # "iommu=pt"
    # 手动禁用 avx2
    # "clearcpuid=156"

    # @todo 不是 systemd 会默认启动 fsck 的吗，这个需要啥
    "fsck.mode=force"
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

  # GPU passthrough with vfio need memlock
  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "infinity"; }
  ];

  services.openssh.enable = true;

  # 默认是 cgroup v2
  # systemd.enableUnifiedCgroupHierarchy = false; # cgroup v1

  # 组装机器之后，这个需求并不强了
  # services.syncthing = {
  #   enable = true;
  #   systemService = true;
  #   # relay.enable = true;
  #   user = "martins3";
  #   dataDir = "/home/martins3";
  #   overrideDevices = false;
  #   overrideFolders = false;
  #   guiAddress = "0.0.0.0:8384";
  # };

  documentation.enable = true;

  # earlyoom 检查方法 sudo journalctl -u earlyoom | grep sending
  # @todo services 和 systemd 的差别是什么?
  systemd.oomd = {
    enable = true;
  };

  services.jenkins.enable = false;

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
    enable = true;
    timerConfig = { OnCalendar = "*-*-* 4:00:00"; };
    wantedBy = [ "timers.target" ];
  };

  systemd.user.timers.qemu = {
    enable = true;
    timerConfig = { OnCalendar = "*-*-* 4:30:00"; };
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

  systemd.user.services.monitor = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/monitor.sh";
      Restart = "no";
    };
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
  # programs.steam.enable = true; # steam 安装

  # 参考 https://gist.github.com/CRTified/43b7ce84cd238673f7f24652c85980b3
  boot.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vmd" "iommu_v2"];
  boot.initrd.kernelModules = ["iommu_v2"];
  boot.blacklistedKernelModules = [ "nouveau" ];

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

  boot.kernel.sysctl = {
    "vm.swappiness" = 200;
    "vm.overcommit_memory" = 1;
  };
}
