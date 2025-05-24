{
  pkgs ? import <nixpkgs> { },
}:

pkgs.llvmPackages.stdenv.mkDerivation {
  name = "rdma";
  hardeningDisable = [ "all" ];
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
# 直接执行其中的 ./build.sh 就可以了
# cd build &&  ninja -t compdb > ../compile_commands.json
