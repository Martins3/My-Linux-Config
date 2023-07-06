# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/libvirt/default.nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    meson
    docutils
    libxml2 # for xmllint
    libxslt # for xsltproc
    gettext
    makeWrapper
    pkg-config
    perl
    perlPackages.XMLXPath
    rpcsvc-proto
    glib
    bash
    bash-completion
    curl
    dbus
    glib
    gnutls
    libgcrypt
    libpcap
    libtasn1
    libxml2
    python3
    readline
    xhtml1
    numad
    yajl
    # @todo 增加一个 WITH_NUMACTL
    libtirpc
  ];
}
# meson build -Ddriver_qemu=enabled -Ddriver_libvirtd=enabled -Ddriver_remote=enabled
# cd build && ninja -j30
# ninja -t compdb > compile_commands.json
# cp compile_commands.json ..
