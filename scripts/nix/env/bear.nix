{ pkgs ? import <nixpkgs> { } }:

# 参考 nixpkgs pkgs/development/tools/build-managers/bear/default.nix
pkgs.stdenv.mkDerivation {
  name = "autoconf";

  nativeBuildInputs = with pkgs.buildPackages; [
    pkg-config
    gcc
    glibc.static
  ];

  buildInputs = with pkgs.pkgsStatic; [
    grpc
    spdlog
    nlohmann_json
    /* cmake */
    /* protobuf */
    /* openssl */
    /* gtest */
    /* c-ares */
    /* zlib */
    /* sqlite */
    /* re2 */
  ];
}

# mkdir -p build && cd build
# cmake -DENABLE_UNIT_TESTS=OFF -DENABLE_FUNC_TESTS=OFF ..
# make all -j32
# make instal
