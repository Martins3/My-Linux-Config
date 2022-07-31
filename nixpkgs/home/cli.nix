{ config, pkgs, stdenv, lib, ... }:

let

in
{

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # compiler && builder
    autoconf
    automake
    gcc
    go
    lua
    clang-tools
    cargo
    rustc
    cmake
    gnumake
    yarn
    nodejs
    # unix tools
    jq
    tmux
    htop
    fzf
    ripgrep
    tree
    binutils
    gdb
    tig
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
    # git
    delta
    gh
    # network
    nethogs
    iftop
    tcpdump
    ethtool
    sshpass
    # nix
    nix-index
    # lib
    readline.dev
    SDL2.dev
    # kernel
    numactl
    kexec-tools
    # numastat TMP_TODO 如何安装这个包
    # qemu
    qemu
    qemu-utils
    ninja
    libvirt
    virt-manager
    meson
    # vim
    neovim
    shellcheck
    shfmt
    rnix-lsp
    # tlpi # TMP_TODO 既没有找到正确的 tlpi，也无法将所有的 tlpi 都编译成功。
    libcap
    acl
    # trace
    pkgs.linuxPackages_latest.perf
    iperf
    bpftrace
    # dpdk
    dpdk
    (
      let
        py-pkgs = pkgs: with pkgs; [
          pandas
          pygal
          pre-commit
          pypinyin
        ];
        python-with-my-packages = python3.withPackages py-pkgs;
      in
      python-with-my-packages
    )
  ];

  xdg.configFile."nvim" = {
    source = ../../nvim;
    recursive = true;
  };

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
      m = "make -j";
      gs = "tig status";
      c = "clear";
      du = "ncdu";
      z = "j";
      mc = "make clean";
      k = "/home/martins3/Sync/vn/docs/qemu/sh/alpine.sh";
    };

    initExtra = "
    eval \"$(jump shell)\"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
    eval \"$(direnv hook zsh)\"

    function edward() {
      pinyin=$(pypinyin -s NORMAL $1)
      printf \"%s\t%s\t1\n\" \"$1\" \"$pinyin\" >> ~/.dotfiles/rime/luna_pinyin.martins3.dict.yaml
    }

    function gscp() {
        file_name=$1
        if [ -z \"file_name\" ]; then
            echo $0 file
            return 1
        fi
        ip=$(ip a | grep -v vir | grep -o \"192\..*\" | cut -d/ -f1)
        file_path=$(readlink -f $file_name)
        echo  scp -r $(whoami)@\${ip}:$file_path .
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
