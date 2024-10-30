{ config, pkgs, stdenv, lib, ... }:

let

# 用这种方法来使用最新的 neovim ，但是不一定编译成功
# neovim = builtins.getFlake "github:neovim/neovim?dir=contrib";
  opt = import ./opt.nix;
in
{
  imports = [
    ./home/cli.nix
  ] ++ (
  if opt.isGui then [
      ./home/gui.nix
    ] else [ ]
  );

  # nixpkgs.overlays = [ neovim.overlay ];
  programs.home-manager.enable = true;
}
