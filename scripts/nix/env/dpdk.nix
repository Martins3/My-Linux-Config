# 参考 https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/dpdk/default.nix 重写一下吧
let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
    ninja
    meson
    python39Packages.pyelftools
  ];
  buildInputs = with pkgs; [ zlib ];
}
