let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation {
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
  ];
}
