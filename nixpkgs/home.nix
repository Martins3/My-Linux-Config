{ config, pkgs, stdenv, lib, ... }:

let

# 用这种方法来使用最新的 neovim ，但是不一定编译成功
# neovim = builtins.getFlake "github:neovim/neovim?dir=contrib";

in
{
  imports = [
    ./home/cli.nix
  ] ++ (
  if builtins.currentSystem == "x86_64-linux" then [
      ./home/gui.nix
    ] else [ ]
  );

  # nixpkgs.overlays = [ neovim.overlay ];
  programs.home-manager.enable = true;
}
