let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation {
# pkgs.clangStdenv.mkDerivation {
  name = "martins3's QEMU";
  buildInputs = with pkgs; [
    zlib
    pkg-config
    ninja
    glib
    pixman
    xorg.libX11.dev
    rdma-core
    liburing
    libiscsi
    libcap_ng
    libslirp
    gtk3
    libaio
    libnfs
    liburing
    libseccomp
    libssh
    libbpf
    libusb1
    zstd
    virglrenderer
    libepoxy
    numactl
    (python3.withPackages (p: with p; [
      sphinx
      sphinx-rtd-theme
    ]))

    flex
    bison
  ];
}
