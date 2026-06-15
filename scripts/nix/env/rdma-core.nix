{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    cmake
    ninja
    gcc
    pkg-config
    libnl
    systemd
    python3
    python3Packages.cython
    python3Packages.docutils
    pandoc
    valgrind
    bear
    clang-tools
  ];

  shellHook = ''
    export CMAKE_GENERATOR=Ninja
    export CMAKE_EXPORT_COMPILE_COMMANDS=1

    echo "rdma-core nix shell ready"
    echo "Build with: cmake -S . -B build -DIN_PLACE=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo && ninja -C build"
  '';
}
# 直接执行其中的 ./build.sh 就可以了
# cd build &&  ninja -t compdb > ../compile_commands.json
