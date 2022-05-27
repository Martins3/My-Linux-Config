{ config, pkgs, stdenv, lib, ... }:

{

  home.packages = with pkgs; [
    tmux
    htop
    xclip
    fzf
    ripgrep
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

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
