{ config, pkgs, stdenv, lib, ... }:

{
  imports = [
    ./home/cli.nix
  ] ++ (if (builtins.getEnv "DISPLAY") != ""
  then [
    ./home/gui.nix
  ] else [ ]);

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
