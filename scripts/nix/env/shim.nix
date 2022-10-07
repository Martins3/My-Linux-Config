# https://github.com/rhboot/shim
{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "hello";
  buildInputs = with pkgs; [
    # 如果缺少 gcc-ar，不要去安装 libgccjit
    gcc_multi
    elfutils
  ];
}
