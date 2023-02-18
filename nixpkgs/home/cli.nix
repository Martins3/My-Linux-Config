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
    nix-index
    virt-manager
    meson
    neovim
    # wakatime
    shellcheck
    shfmt
    rnix-lsp # nix 语言的 lsp
    tree-sitter
    pkgs.linuxPackages_latest.perf
    # linuxHeaders @todo 这个东西和 stable 和 latest 的内核不是配套的哇
    # 这个东西其实自己生成一份
    # 关键在于这里提供的内容不对: (import <nixpkgs> {}).linuxPackages_latest.kernel.dev
    iperf
    unstable.bpftrace # bpftrace 新版本才支持 kfunc
    unstable.bcc
    sqlite
    sysstat # sar, iostat and pidstat mpstat
    pstree
    dpdk
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
    # perl
    man-pages
    man-pages-posix
    # x86-manpages # @todo 为什么 rnix-lsp 可以，但是 x86-manpages 不可以
    lazydocker
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
    xcp # better cp
    procs # better ps
    cloc
    tokei # 代码统计工具，比 cloc 性能好
    zellij # tmux 替代品
    sshfs
    firecracker
    (import (fetchTarball https://github.com/cachix/devenv/archive/v0.5.tar.gz)) # @todo 和 default.nix 有区别？
    bridge-utils
    swtpm # windows 11 启动需要
    nushell
    libnotify

    containerd # @todo 测试下
    nerdctl

    telegraf # @todo 这个和 service 是什么关系？
    usbutils
    # 测试下 ovs @todo
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
