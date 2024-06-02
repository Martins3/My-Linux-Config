let
  pkgs = import <nixpkgs> { };
in
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "rime";
  buildInputs = with pkgs; [
    libclang
  ];
  LIBCLANG_PATH="${pkgs.libclang.lib}/lib";
}
