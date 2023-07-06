{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "static";

  nativeBuildInputs = with pkgs.buildPackages; [
    gcc
    glibc.static
    # 使用的动态库放到这里
  ];

  buildInputs = with pkgs.pkgsStatic; [
    # 如果你依赖更多的静态库
  ];
}
# @todo 运行一个 shell 然后自动使用这个环境
