{ config, pkgs, stdenv, lib, ... }:

{
  imports = [
    ./home/cli.nix
  ] ++ (
  if builtins.currentSystem == "x86_64-linux" then [
      ./home/gui.nix
    ] else [ ]
  );


  # 为了保证任何时候都安装 im-select ，否则无法
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };

  # allow unfree software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (pkgs.fetchFromGitHub {
      # https://github.com//NUR/commit/
      owner = "nix-community";
      repo = "NUR";
      rev = "1970f883e139b06ae109ad2ca2c45b7fa987afb9";
      sha256 = "0ln72j456xzkny8xk5l72agrqif25bmxhlvay8v6kyazsa3xmaks";
    }) {
      inherit pkgs;
    };
  };

  programs.home-manager.enable = true;
}
