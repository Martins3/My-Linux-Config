let
pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
	nativeBuildInputs = with pkgs.buildPackages; [
		libaio
			python3 zlib liburing
			pkg-config
			autoconf
			gettext
			autoconf-archive
			automake
			libtool
			bison
			flex
	];
	buildInputs = with pkgs; [ zlib ];
}
