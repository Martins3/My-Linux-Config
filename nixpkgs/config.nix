{
  allowUnsupportedSystem = false;
  allowUnfree = true;
  packageOverrides = pkgs: rec {
    # 添加nix user repository (NUR)到nixpkgs里。
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      pkgs = pkgsu;
    };
    # 添加非稳定版的nixpkgs到nixpkgs里，
    # 比如非稳定版的hello可以通过`pkgs.pkgsu.hello`来访问。
    pkgsu = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {};
  };
}
