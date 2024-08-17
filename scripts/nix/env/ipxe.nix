{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "ipxe";
  buildInputs = with pkgs; [
    gnu-efi
    mtools
    openssl
    perl
    xorriso
    xz
    syslinux
  ];
}

# git clone https://github.com/ipxe/ipxe
# cd ipxe/src
# make 测试失败
# 可以
# make bin/ipxe.lkrn bin-x86_64-efi/ipxe.efi
# ./util/genfsimg -o ipxe.iso bin/ipxe.lkrn bin-x86_64-efi/ipxe.efi
#
# nix-build -E '(import <nixpkgs> {}).syslinux' --no-out-link
# 参考这里，似乎比想象的复杂
# pkgs/tools/misc/ipxe/default.nix
