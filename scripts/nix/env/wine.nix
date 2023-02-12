let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell
rec {
  buildInputs = with pkgs; [
    bison
    flex
    fontforge
    makeWrapper
    pkg-config

    # Required by staging
    autoconf
    hexdump
    perl

    libcap
    cups
    gettext
    dbus
    cairo
    unixODBC
    samba4
    ncurses
    libva
    libpcap
    libv4l
    sane-backends
    libgphoto2
    libkrb5
    fontconfig
    alsa-lib
    libpulseaudio
    xorg.libXinerama
    udev
    vulkan-loader
    SDL2
    libusb1
    gtk3
    glib
    opencl-headers
    ocl-icd
    openssl
    gnutls
    libGLU
    libGL
    mesa.osmesa
    libdrm
    gnutls
  ];
}
# CFLAGS="-g -O0" ./configure --enable-win64 --without-freetype
# make
