{ config, pkgs, stdenv, lib, ... }:

let
  unstable = import <unstable> { };
  rnix-lsp2 = import (fetchTarball "https://github.com/nix-community/rnix-lsp/archive/master.tar.gz");
  x86-manpages = import (fetchTarball "https://github.com/blitz/x86-manpages-nix/archive/master.tar.gz");
in
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # compiler && builder
    autoconf
    automake
    pkg-config
    gcc
    go
    lua
    unstable.sumneko-lua-language-server
    clang-tools
    cargo
    rustc
    rust-analyzer
    cmake
    gnumake
    yarn
    nodejs
    tmux
    tmuxp
    tig
    xclip
    jq
    htop
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
    rnix-lsp2
    tree-sitter
    # trace
    pkgs.linuxPackages_latest.perf
    iperf
    bpftrace
    sysstat # sar, iostat and pidstat mpstat
    # dpdk
    dpdk

    # python
    (python3.withPackages (p: with p; [
      pandas
      pygal
      pre-commit
      ipython
      filelock
      autopep8
    ]))
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
  ];

  home.file.".tmux/plugins/tpm" = {
    source = builtins.fetchGit {
      url = "https://github.com/tmux-plugins/tpm";
      rev = "b699a7e01c253ffb7818b02d62bce24190ec1019"; # updated at 2022/7/17
    };
  };

  home.file.tmux = {
    source = ../../conf/tmux.conf;
    target = ".tmux.conf";
  };

  home.file.tig = {
    source = ../../conf/tigrc.conf;
    target = ".tigrc";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      sync-config = "rsync --delete -avzh --filter=\"dir-merge,- .gitignore\" maritns3@10.0.2.2:~/.dotfiles ~/";
      update-sys = "sync-config && sudo nixos-rebuild switch";
      update-home = "sync-config && home-manager switch";
      px = "export https_proxy=10.0.2.2:8889 && export http_proxy=10.0.2.2:8889 && export HTTPS_PROXY=10.0.2.2:8889 && export HTTP_PROXY=10.0.2.2:8889";
      q = "exit";
      v = "nvim";
      ls = "lsd";
      ldc = "lazydocker";
      m = "make -j";
      gs = "tig status";
      c = "clear";
      du = "ncdu";
      z = "j";
      mc = "make clean";
      k = "/home/martins3/Sync/vn/docs/qemu/sh/alpine.sh";
      flamegraph = "/home/martins3/Sync/vn/docs/kernel/code/flamegraph.sh";
      en_direnv = "echo \"use nix\" >> .envrc && direnv allow";
      env_docker = "docker run -it --rm -u $(id -u):$(id -g) -v $(pwd):/home/martins3/src"; # kernel-build-container:gcc-7
      knews = "~/.dotfiles/scripts/systemd/news.sh kernel";
      qnews = "~/.dotfiles/scripts/systemd/news.sh qemu";
      ck = "systemctl --user start kernel";
      cq = "systemctl --user start qemu";
      git_ignore = "echo \"$(git status --porcelain | grep '^??' | cut -c4-)\" > .gitignore";
    };

    # TMP_TODO 这样写是非常不优雅的
    initExtra = "
    eval \"$(jump shell)\"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
    eval \"$(direnv hook zsh)\"
    eval \"$(starship init zsh)\"

    function gscp() {
      file_name=$1
      if [ -z \"file_name\" ]; then
        echo $0 file
        return 1
      fi
      ip=$(ip a | grep -v vir | grep -o \"192\..*\" | cut -d/ -f1)
      file_path=$(readlink -f $file_name)
      echo scp -r $(whoami)@\${ip}:$file_path .
    }

    function rpm_extract() {
      rpm2cpio $1 | cpio -idmv
    }
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
    userName = "martins3";
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
    source = ../../conf/gdbinit;
    target = ".gdbinit.d/init";
  };

  home.file.cargo_conf = {
    source = ../../conf/cargo.conf;
    target = ".cargo/config";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
