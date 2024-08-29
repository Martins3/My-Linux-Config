# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/libvirt/default.nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    # @todo 增加一个 WITH_NUMACTL
    bash
    bash-completion
    curl
    dbus
    docutils
    gettext
    glib
    gnutls
    libgcrypt
    libpcap
    libtasn1
    libtirpc
    libxml2 # for xmllint
    libxslt # for xsltproc
    makeWrapper
    meson
    numad
    perl
    perlPackages.XMLXPath
    pkg-config
    python3
    readline
    rpcsvc-proto
    xhtml1
    yajl
  ];
}
# 如果重新配置 meson setup --reconfigure build
# meson setup build -Ddriver_qemu=enabled -Ddriver_libvirtd=enabled -Ddriver_remote=enabled
# cd build && ninja -j30
# ninja -t compdb > compile_commands.json
# cp compile_commands.json ..
