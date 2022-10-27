{ config, pkgs, stdenv, lib, ... }:

let
  unstable = import <unstable> { };
  rnix-lsp2 = import (fetchTarball "https://github.com/nix-community/rnix-lsp/archive/master.tar.gz");
  x86-manpages = import (fetchTarball "https://github.com/blitz/x86-manpages-nix/archive/master.tar.gz");
in
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    autoconf
    automake
    pkg-config
    gcc
    mold
    go
    lua
    unstable.sumneko-lua-language-server
    unstable.clang-tools
    cargo
    rustc
    unstable.rust-analyzer
    cmake
    gnumake
    yarn
    nodejs
    tmux
    tmuxp
    tig
    xclip
    jq
    xplr
    htop
    btop
    unzip
    fzf
    ripgrep
    silver-searcher
    binutils
    starship
    gdb
    lsd
    lsof
    ccls
    bear
    tree
    jump
    fd
    cloc
    file
    ncdu
    socat # unix domain
    delta # git diff
    git-secrets
    nethogs
    iftop
    tcpdump
    ethtool
    sshpass
    gping # better ping
    unstable.pingu
    nbd
    # nix
    nix-index
    # kernel
    numactl
    kexec-tools
    rpm
    stress-ng
    numatop
    # qemu
    # OVMF # TMP_TODO 安装了，但是 OVMF.fd 没有找到
    qemu
    ninja
    libvirt
    virt-manager
    meson
    # vim
    unstable.neovim
    shellcheck
    shfmt
    # TMP_TODO 通过这种方法会失败，似乎是从 crates.io 下载的问题
    # rnix-lsp2
    rnix-lsp
    tree-sitter
    # trace
    pkgs.linuxPackages_latest.perf
    iperf
    bpftrace
    sysstat # sar, iostat and pidstat mpstat
    pstree
    dpdk
    (python3.withPackages (p: with p; [
      pandas
      pygal
      pre-commit
      ipython
      filelock
      autopep8
    ]))
    perl
    man-pages
    man-pages-posix
    # TMP_TODO 为什么 rnix-lsp 可以，但是 x86-manpages 不可以
    # x86-manpages
    lazydocker
    nixos-generators
    unstable.gum
    # acpi
    acpica-tools
    asciidoc
    # iscsi # TMP_TODO iscsi 没有完全搞明白，所以在 nixos 上更加不会
    targetcli
    fio
    # fun
    genact # A nonsense activity generator
    wtf # The personal information dashboard for your terminal
    unstable.nixos-shell
    viddy # A modern watch command.
    mcfly # better ctrl-r for shell
  ];

  home.file.".tmux/plugins/tpm" = {
    source = builtins.fetchGit {
      url = "https://github.com/tmux-plugins/tpm";
      rev = "b699a7e01c253ffb7818b02d62bce24190ec1019"; # updated at 2022/7/17
    };
  };

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
    userName = "bachelor hu";
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

      /*
        http={
        proxy = "http://10.0.2.2:8889";
        };
        https={
        proxy = "http://10.0.2.2:8889";
        };
      */
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

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
