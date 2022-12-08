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
    ninja
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
    yajl
  ];
}
# meson build
# cp build/compile_commands.json .
