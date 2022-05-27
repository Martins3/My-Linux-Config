{ config, pkgs, stdenv, lib, ... }:

{

  home.packages = with pkgs; [
    tmux
  ]

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
