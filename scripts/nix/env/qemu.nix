let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation {
# pkgs.clangStdenv.mkDerivation {
  name = "martins3's QEMU";
  buildInputs = with pkgs; [
    zlib
    pkgconfig
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
    libseccomp
    libssh
    libbpf
    libusb
    zstd
    virglrenderer
    epoxy
    numactl
    (python3.withPackages (p: with p; [
      sphinx
      sphinx-rtd-theme
    ]))

    flex
    bison
  ];
}
