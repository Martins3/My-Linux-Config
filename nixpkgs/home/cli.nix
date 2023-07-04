{ config, pkgs, stdenv, lib, ... }:

let
  unstable = import <unstable> { };
  x86-manpages = import (fetchTarball "https://github.com/blitz/x86-manpages-nix/archive/master.tar.gz");

in
{
  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  home.username = "martins3";
  home.homeDirectory = "/home/martins3";

  home.packages = with pkgs; [
    gcc
    mold
    go
    lua
    lua-language-server
    stylua
    ccls
    cargo
    rustc
    unstable.rust-analyzer
    cmake
    # zig
    gnumake
    marksman
    yarn
    nodejs
    tmux
    tmuxp
    screen
    tig
    xclip # x clipboard
    wl-clipboard # wayland clipboard
    jq
    aspell
    aspellDicts.en
    yq-go
    xplr
    htop
    btop
    unzip
    fzf
    ripgrep
    binutils
    starship
    gdb
    lsof
    lshw
    hw-probe #  sudo -E hw-probe -all -upload
    exa # more powerful ls
    oh-my-posh # @todo for powershell
    gource
    neofetch
    bear
    tree
    fd
    file
    duf # 更好的 df -h
    zoxide # better jump
    ncdu # 更加易用的 du
    du-dust # 比 ncdu 更快
    socat # unix domain
    delta # git diff
    git-secrets
    nethogs
    nmap
    # dhcpcd # 这个东西和 nixos 不兼容
    iftop
    neomutt
    weechat
    offlineimap
    tcpdump
    ethtool
    proxychains-ng
    sshpass
    gping # better ping
    auto-cpufreq
    frp
    pingu # interesting ping
    nbd
    kmon # 方便的管理内核模块
    numactl
    kexec-tools
    helix # modern neovim
    rpm
    stress-ng
    numatop
    OVMFFull # 存储在 /run/libvirt/nix-ovmf/ 下
    # 通过 tweaks 调整开机自启动
    gnome3.gnome-tweaks # @todo 确定是这里设置的，还是只是一个 extension
    hexyl # 分析二进制
    rasdaemon # @todo 莫名其妙，不知道怎么使用
    nvme-cli
    ninja
    libvirt # 提供 virsh
    qemu
    virtiofsd # 之前 https://gitlab.com/virtio-fs/virtiofsd ，似乎之前是在 qemu 中的
    podman
    nix-index
    # virt-manager @todo 这到底是个啥，需要使用上吗？
    meson
    unstable.neovim
    efm-langserver # 集成 shellcheck
    # wakatime
    shellcheck
    shfmt
    tree-sitter
    systeroid
    linuxKernel.packages.linux_5_15.perf
    # @todo 也许替换为 linuxPackages_latest.perf
    iperf
    # linuxPackages_latest.systemtap # 似乎这个让 libvirt 的编译开始依赖 systemdtab 的头文件了
    # 其实也不能用
    # ERROR: kernel release isn't found in "/nix/store/n3nrix9pc0m1ywzg8dq71bh2xr82c7l5-linux-6.3.5-dev"
    # 还是在虚拟机勉强维持生活吧
    unstable.bpftrace # bpftrace 新版本才支持 kfunc
    heaptrack
    kernelshark
    trace-cmd
    ltrace # library trace
    unstable.bcc
    # @todo 不知道为什么居然又两个程序
    # 应该对应的这个: https://github.com/libbpf/bpftool/tree/master/src
    bpftool
    bpftools
    acpi
    liburing
    cpuid
    # @todo https://github.com/kkharji/sqlite.lua 需要设置 libsqlite3.so 的位置
    sqlite
    parted
    sysbench
    linuxKernel.packages.linux_latest_libre.turbostat
    wirelesstools
    dos2unix
    # @todo 传统调试工具专门整理为一个包
    sysstat # sar, iostat and pidstat mpstat
    # dpdk
    # firecracker
    inetutils
    (python3.withPackages (p: with p; [
      pandas
      pygal
      ipython
      filelock
      autopep8
      libvirt
      mock
      filelock
      grpcio
      pytest
      monotonic
      libxml2
      ansible # 自动化运维
    ]))
    # ruff # 类似 pyright，据说很快，但是项目太小，看不出什么优势
    # perl
    nodePackages.pyright
    black # python formatter
    man-pages
    pre-commit
    tiptop
    atop
    nmon
    man-pages-posix
    # x86-manpages # @todo 为什么 rnix-lsp 可以，但是 x86-manpages 不可以
    lazydocker
    distrobox # 基于容器来提供各种 distribution
    arp-scan
    pcm
    nixos-generators
    unstable.gum
    # acpi
    acpica-tools
    asciidoc
    # iscsi # @todo 尚未使用过
    targetcli
    fio
    genact # A nonsense activity generator
    wtf # The personal information dashboard for your terminal
    unstable.nixos-shell
    progress # 展示 cp dd 之类的进度条
    psmisc # 包含 pstree fuser 等工具
    viddy # A modern watch command.
    # mcfly # better ctrl-r for shell
    unstable.atuin
    pciutils
    powertop # 分析功耗
    lm_sensors # 获取 CPU 温度
    libxfs # @todo 使用 sudo mkfs.xfs -f /dev/sda1 还是需要 nix-shell -p libxfs
    # @todo 使用了 xfs 之后，测试磁盘 IOPS 明显不对
    libcgroup
    cpulimit
    bat # better cat
    procs # better ps
    cloc
    tokei # 代码统计工具，比 cloc 性能好
    unstable.zellij # tmux 替代品
    stagit # git static site generator 相当有趣
    sshfs
    # kvmtool
    packer # 制作 qcow2 镜像
    (import (fetchTarball https://github.com/cachix/devenv/archive/v0.5.tar.gz)) # @todo 和 default.nix 有区别？
    bridge-utils
    swtpm # windows 11 启动需要
    unstable.nushell
    libnotify # 通知小工具
    # 才知道在 Linux 下也是可以用的 pwsh
    # 在 nixos 23.04 这个版本中，暂时因为 ssl 的版本，不能使用
    # powershell
    dmidecode # sudo dmidecode -t 1
    git-review

    containerd # @todo 测试下
    nerdctl
    usbutils
    # @todo 测试下 ovs

    openjdk
    # dockerTools @todo # 使用 nixos 构建 docker
    # https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools
    asciiquarium
    # ipmiview # supermicro 服务器配套设施，装不上
    bc # bash 数值计算

    verilator # Fast and robust (System)Verilog simulator/compiler

    cowsay
    figlet # 艺术字
    lolcat # 彩虹 cat
    nyancat # 彩虹猫咪
    dig # dns分析
    iptraf-ng # 网络流量分析
    glances # 又一个 htop
    zenith-nvidia # TODO
    smartmontools # 监视硬盘健康
    httpie # http baidu.com

    lcov
  ];

  programs.zsh = {
    enable = true;
    shellAliases = { };
    initExtra = "
    source /home/martins3/.dotfiles/config/zsh
    source /home/martins3/core/zsh/zsh
    ";

    plugins = [
      {
        name = "zsh-autosuggestions";
        file = "zsh-autosuggestions.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/zsh-users/zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userEmail = "hubachelar@gmail.com";
    userName = "Martin Hu";
    extraConfig = {
      # https://github.com/dandavison/delta
      # --- begin
      core = {
        editor = "nvim";
        pager = "delta";
        abbrev = 12;
      };
      pretty={
        fixes = "Fixes: %h (\"%s\")";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = "true";
        light = "false";
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      # --- end

      http = {
        proxy = "http://127.0.0.1:8889";
      };

      https = {
        proxy = "http://127.0.0.1:8889";
      };

      credential = {
        helper = "store";
      };

      alias = {
        # 查询一个 merge commit 中的数值
        # https://stackoverflow.com/questions/6191138/how-to-see-commits-that-were-merged-in-to-a-merge-commit
        log-merge = "!f() { git log --oneline --graph --stat \"$1^..$1\"; }; f";
        # 优雅的打印
        # https://stackoverflow.com/questions/6191138/how-to-see-commits-that-were-merged-in-to-a-merge-commit
        adog = "log --all --decorate --oneline --graph";
      };
    };
  };

  home.file.gdbinit = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/2b107b27949d13f6ef041de6eec1ad2e5f7b4cbf/.gdbinit";
      sha256 = "02rxyk8hmk7xk1pyhnc5z6a2kqyd63703rymy9rfmypn6057i4sr";
      name = "gdbinit";
    };
    target = ".gdbinit";
  };

  home.file.gdb_dashboard_init = {
    source = ../../config/gdbinit;
    target = ".gdbinit.d/init";
  };

  home.file.npm = {
    source = ../../config/npmrc;
    target = ".npmrc";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
