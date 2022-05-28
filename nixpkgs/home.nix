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
    zsh
    yarn
    clang-tools
    cmake
    gnumake
    capstone
    ## python
    python3
    nodejs
    ## c
    binutils
    gcc
    gdb
    alacritty
    tig
    /* (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; }) */
  ];

/* 参考: https://breuer.dev/blog/nixos-home-manager-neovim */
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
    source = ../conf/tmux.conf
    target = ".tmux.conf";
};

home.file.tig= {
    source = ../conf/tigrc.conf
    target = ".tigrc";
};

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
