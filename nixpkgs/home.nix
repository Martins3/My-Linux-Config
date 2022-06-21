{ config, pkgs, stdenv, lib, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    tmux
    htop
    xclip
    fzf
    ripgrep
    tree
    yarn
    clang-tools
    cmake
    gnumake
    python3
    nodejs
    binutils
    gcc
    gdb
    alacritty
    tig
    go
    lsd
    xclip
    ccls
    bear
    tree
    jump
    # nix
    nix-index
    fd
    ncdu
    # lib
    readline.dev
    SDL2.dev
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

/* reference: https://breuer.dev/blog/nixos-home-manager-neovim */
nixpkgs.overlays = [
  (import (builtins.fetchTarball {
    url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  }))
];

programs.neovim = {
  enable = true;
  package = pkgs.neovim-nightly;
};

xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
};

xdg.configFile."alacritty.yml" = { source = ../conf/alacritty.yml; };

home.file.tmux = {
    source = ../conf/tmux.conf;
    target = ".tmux.conf";
};

home.file.tig= {
    source = ../conf/tigrc.conf;
    target = ".tigrc";
};

/* loongson_server="loongson@10.90.50.30" */
/* alias la="ssh -X -t ${loongson_server} \"tmux attach || /usr/bin/tmux\"" */
/* alias sshfs_la="sshfs ${loongson_server}:/home/loongson ~/core/5000" */
programs.zsh = {
  enable = true;
  shellAliases = {
    update-sys = "sudo nixos-rebuild switch";
    update-home = "home-manager switch";
    px="export https_proxy=10.0.2.2:8889 && export http_proxy=10.0.2.2:8889";
    q="exit";
    v="nvim";
    ls="lsd";
    m="make -j";
    gs="tig status";
    fd="fdfind";
    c="clear";
    du="ncdu";
    z="j";
    mc="make clean";
    sync-config="rsync --delete -avzh --filter=\"dir-merge,- .gitignore\" maritns3@10.0.2.2:~/.dotfiles ~/";
  };

  initExtra= "
    eval \"$(jump shell)\"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
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

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
