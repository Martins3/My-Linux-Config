{ config, pkgs, stdenv, lib, ... }:

{
  imports = [
    ./usr/cli.nix
  ] ++ (if (builtins.getEnv "DISPLAY")!=""
  then [
    ./usr/gui.nix
  ] else []);

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
