let
  pkgs = import <nixpkgs> { };
in
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "rime";
  buildInputs = with pkgs; [
    libclang
    librime
  ];
  LIBCLANG_PATH="${pkgs.libclang.lib}/lib";
}
