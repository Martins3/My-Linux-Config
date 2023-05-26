{ config, pkgs, stdenv, lib, ... }:

let
  unstable = import <unstable> { };
  rnix-lsp2 = import (fetchTarball "https://github.com/nix-community/rnix-lsp/archive/master.tar.gz");
  x86-manpages = import (fetchTarball "https://github.com/blitz/x86-manpages-nix/archive/master.tar.gz");

in
{
  fonts.fontconfig.enable = true;

  home.stateVersion = "21.11";
  home.username = "martins3";
  home.homeDirectory = "/home/martins3";

  home.packages = with pkgs; [
    gcc
    mold
    go
    lua
    unstable.sumneko-lua-language-server
    ccls
    cargo
    rustc
    unstable.rust-analyzer
    cmake
    # zig
    gnumake
    yarn
    nodejs
    tmux
    tmuxp
    screen
    tig
    xclip # x clipboard
    wl-clipboard # wayland clipboard
    jq
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
    exa # more powerful ls
    oh-my-posh # @todo for powershell
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
    bpftool
    nethogs
    nmap
    # dhcpcd # 这个东西和 nixos 不兼容
    iftop
    tcpdump
    ethtool
    sshpass
    gping # better ping
    pingu # interesting ping
    nbd
    kmon # 方便的管理内核模块
    numactl
    kexec-tools
    rpm
    stress-ng
    numatop
    OVMFFull # 存储在 /run/libvirt/nix-ovmf/ 下
    ninja
    libvirt # 提供 virsh
    qemu
    nix-index
    # virt-manager @todo 这到底是个啥，需要使用上吗？
    meson
    unstable.neovim
    efm-langserver # 集成 shellcheck
    # wakatime
    shellcheck
    shfmt
    rnix-lsp # nix 语言的 lsp
    tree-sitter
    systeroid
    linuxKernel.packages.linux_5_15.perf
    # TODO 6.3 内核无法编译了
    # pkgs.linuxPackages_latest.perf # @todo perf 开始提示缺少 libtraceevent 来支持 tracepoint 了
    # linuxHeaders @todo 这个东西和 stable 和 latest 的内核不是配套的哇
    # 这个东西其实自己生成一份
    # 关键在于这里提供的内容不对: (import <nixpkgs> {}).linuxPackages_latest.kernel.dev
    iperf
    unstable.bpftrace # bpftrace 新版本才支持 kfunc
    kernelshark # @todo 使用一下
    trace-cmd
    ltrace # 检查程序使用的库
    unstable.bcc
    acpi
    cpuid
    # @todo https://github.com/kkharji/sqlite.lua 需要设置 libsqlite3.so 的位置
    sqlite
    parted
    sysbench
    linuxKernel.packages.linux_latest_libre.turbostat
    /* linuxKernel.packages.linux_latest_libre.systemtap */ # @todo 这个让 libvirt 的编译开始依赖 systemdtab 的头文件了
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
      pre-commit
      ipython
      filelock
      autopep8
      libvirt
      mock
      filelock
      grpcio
      pytest
      unittest2
      monotonic
      libxml2
      ansible # 自动化运维
    ]))
    # ruff # 类似 pyright，据说很快，但是项目太小，看不出什么优势
    # perl
    man-pages
    tiptop
    atop
    nmon
    man-pages-posix
    # x86-manpages # @todo 为什么 rnix-lsp 可以，但是 x86-manpages 不可以
    lazydocker
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
    powershell # 才知道在 Linux 下也是可以用的 pwsh
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
    smartmontools # 监视硬盘健康
    httpie # http baidu.com
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
    userName = "Martins3";
    extraConfig = {
      # https://github.com/dandavison/delta
      # --- begin
      core = {
        editor = "nvim";
        pager = "delta";
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
