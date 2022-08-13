# TMP_TODO 显然这个也是可以简化一下的
let
  pkgs = (import <nixpkgs>) { };
  gcc = pkgs.gcc;
  stdenv = pkgs.stdenv;
in
stdenv.mkDerivation {
  name = "hello";
  nativeBuildInputs = with pkgs; [
    # 如果缺少 gcc-ar，不要去安装 libgccjit
    gcc_multi
  ];

  buildInputs = with pkgs; [
    elfutils
  ];
}
