{
  description = "Modular Nix development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Base development shell
        baseDevShell = { packages ? [], extraShellHook ? "", env ? {} }: pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            curl
            wget
            vim
            tmux
            direnv
          ] ++ packages;

          # Set environment variables
          shellHook = ''
            echo "Environment activated with ${builtins.toString (builtins.length packages)} packages"
            ${extraShellHook}
          '' // (builtins.concatStringsSep "\n" 
               (builtins.map (key: "export ${key}=\"${env.${key}}\"") 
                (builtins.attrNames env)));
        };

        # Reusable modules for common project types
        modules = {
          # C/C++ development
          cc = {
            packages = with pkgs; [
              gcc
              clang
              cmake
              ninja
              pkg-config
              gdb
              valgrind
              lldb
            ];
            extraShellHook = "";
            env = {};
          };

          # Rust development
          rust = {
            packages = with pkgs; [
              rustc
              cargo
              rustfmt
              clippy
              rust-analyzer
              rustPlatform.bindgenHook
              rustup
            ];
            extraShellHook = ''
              export PATH="$HOME/.cargo/bin:$PATH"
            '';
            env = {
              RUST_BACKTRACE = "full";
            };
          };

          # LLVM project development (matches your existing llvm.nix)
          llvm = {
            packages = with pkgs; [
              clang
              llvm
              cmake
              ninja
              python3
            ] ++ (with pkgs.python3Packages; [
              llvmlite
              numpy
            ]);
            extraShellHook = ''
              # LLVM-specific environment variables
              export LLVM_ROOT="${pkgs.llvm}"
            '';
            env = {};
          };

          # Python development
          python = {
            packages = with pkgs; [
              python3
              pip
              virtualenv
              (python3.withPackages (p: with p; [
                numpy
                requests
                pytest
                black
                flake8
              ]))
            ];
            extraShellHook = ''
              export PYTHONPATH=".:$PYTHONPATH"
            '';
            env = {};
          };

          # Go development
          go = {
            packages = with pkgs; [
              go
              gopls
              delve
            ];
            extraShellHook = ''
              export GOPATH="$HOME/go"
              export PATH="$GOPATH/bin:$PATH"
            '';
            env = {};
          };

          # Node.js development
          nodejs = {
            packages = with pkgs; [
              nodejs
              yarn
              npm
              typescript
            ];
            extraShellHook = ''
              export PATH="$PWD/node_modules/.bin:$PATH"
            '';
            env = {};
          };

          # Database tools
          database = {
            packages = with pkgs; [
              postgresql
              sqlite
              redis
            ];
            extraShellHook = "";
            env = {};
          };

          # System tools (similar to some of your existing files)
          system-tools = {
            packages = with pkgs; [
              gdb
              valgrind
              strace
              perf
              lsof
              htop
            ];
            extraShellHook = "";
            env = {};
          };
        };

        # Helper function to create dev shell by combining modules
        createDevShell = moduleNames:
          let
            moduleConfigs = builtins.map (name: modules.${name}) moduleNames;
            allPackages = builtins.foldl' (acc: cfg: acc ++ cfg.packages) [] moduleConfigs;
            allShellHooks = builtins.concatStringsSep "\n" (builtins.map (cfg: cfg.extraShellHook) moduleConfigs);
            allEnvs = builtins.foldl' (acc: cfg: acc // cfg.env) {} moduleConfigs;
          in
          baseDevShell {
            packages = allPackages;
            extraShellHook = allShellHooks;
            env = allEnvs;
          };

        # Project-specific configurations that match your existing files
        projects = {
          # Match your existing glibc setup
          glibc = createDevShell [ "cc" "system-tools" ];
          
          # Match your existing qemu setup
          qemu = createDevShell [ "cc" "system-tools" ];
          
          # Match your existing linux kernel setup
          linux = createDevShell [ "cc" "system-tools" ];
          
          # Match your existing rust setups
          rust-best = createDevShell [ "rust" "cc" ];
          rust-simple = createDevShell [ "rust" ];
          rust-complex = createDevShell [ "rust" "cc" "database" ];
          
          # DPDK, SPDK, etc. - mostly C/C++ with system tools
          dpdk = createDevShell [ "cc" "system-tools" ];
          spdk = createDevShell [ "cc" "system-tools" ];
          xdp = createDevShell [ "cc" "system-tools" ];
          bcc = createDevShell [ "cc" "system-tools" ];
          libbpf = createDevShell [ "cc" "system-tools" ];
        };
      in
      {
        # Predefined devShells
        devShells = {
          # Default shell
          default = createDevShell [ "cc" ];
          
          # C/C++ development
          cc = createDevShell [ "cc" ];
          
          # Rust development
          rust = createDevShell [ "rust" ];
          
          # LLVM development
          llvm = createDevShell [ "cc" "llvm" ];
          
          # Full stack development
          fullstack = createDevShell [ "cc" "python" "nodejs" "rust" "go" ];
          
          # Custom shells combining multiple modules
          python-cc = createDevShell [ "cc" "python" ];
          rust-cc = createDevShell [ "cc" "rust" ];
          web = createDevShell [ "nodejs" "python" ];
          
          # Project-specific shells
          glibc = projects.glibc;
          qemu = projects.qemu;
          linux = projects.linux;
          rust-best = projects.rust-best;
          rust-simple = projects.rust-simple;
          rust-complex = projects.rust-complex;
          dpdk = projects.dpdk;
          spdk = projects.spdk;
          xdp = projects.xdp;
          bcc = projects.bcc;
          libbpf = projects.libbpf;
        };

        # Reusable packages for direct use
        packages = {
          # Some example packages that might be useful
          inherit (pkgs) 
            gcc 
            clang 
            rustc 
            go 
            python3 
            nodejs;
        };
      });
}