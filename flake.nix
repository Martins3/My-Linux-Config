{
  description = "Dotfiles with Nix environment management";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        apps = {
          select-env = flake-utils.lib.mkApp {
            drv = pkgs.writeShellApplication {
              name = "select-env";
              runtimeInputs = with pkgs; [ fzf jq ];
              text = ''
                exec ${./nix/envs}/select-env.sh "$@"
              '';
            };
          };
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ git vim tmux ];
          };
        };
      });
}