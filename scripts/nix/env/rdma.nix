{
  pkgs ? import <nixpkgs> { },
}:

# 各种 C 环境合集都放这里了
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "C";
  buildInputs = with pkgs; [
    cmake
    pkg-config
    python3
    libnl
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_RUNDIR=/run"
    "-DCMAKE_INSTALL_SHAREDSTATEDIR=/var/lib"
  ];

}
