# Improved Nix Environment Management System

## Overview

This new system replaces the repetitive individual `.nix` files in `scripts/nix/env/` with a modular, maintainable approach using Nix flakes.

## Key Benefits

- **Modularity**: Reusable modules for common development needs
- **Maintainability**: Centralized configuration instead of many repeated files
- **Extensibility**: Easy to add new project types by combining existing modules
- **Consistency**: Unified approach across all projects

## Structure

```
nix/envs/
├── flake.nix           # Main flake with all devShells
├── select-env.sh       # New script to select environments
└── README.md           # This documentation
```

## Available Development Environments

The system provides several pre-configured environments:

### Base Environments
- `default` - Basic C/C++ development tools
- `cc` - C/C++ development (gcc, clang, cmake, etc.)
- `rust` - Rust development (rustc, cargo, rust-analyzer, etc.)
- `python` - Python development
- `nodejs` - JavaScript/Node.js development
- `go` - Go development

### Combined Environments
- `rust-cc` - Rust + C/C++ development
- `python-cc` - Python + C/C++ development
- `web` - Web development (Node.js + Python)
- `fullstack` - All development tools combined

### Project-Specific Environments
- `llvm` - LLVM development environment
- `glibc`, `qemu`, `linux`, `dpdk`, `spdk`, etc. - Project-specific shells

## Usage

### Selecting an Environment

1. Navigate to your project directory
2. Run the selection script:
```bash
nix run ~/.dotfiles/nix/envs#select-env
```

Or if you want to place the script in your PATH:
```bash
~/.dotfiles/nix/envs/select-env.sh
```

3. Choose your desired environment from the fuzzy finder
4. The system will automatically update your `.envrc` and allow it with direnv

### Direct Usage

You can also enter environments directly without setting up direnv:

```bash
# Enter the LLVM development environment directly
nix develop ~/.dotfiles/nix/envs#llvm

# Enter Rust development environment
nix develop ~/.dotfiles/nix/envs#rust
```

## Module System

The system is built on reusable modules that can be combined:

- `cc`: C/C++ toolchain
- `rust`: Rust toolchain
- `python`: Python environment
- `llvm`: LLVM-specific packages
- `database`: Database tools
- `system-tools`: System debugging tools (gdb, valgrind, etc.)

## Adding New Environments

To add a new environment, modify `flake.nix` by:

1. Adding a new module to the `modules` attribute in the flake
2. Creating a new devShell that uses the module in the `devShells` section
3. Or combining multiple modules for complex setups

Example:
```nix
my-project = createDevShell [ "cc" "database" ];
```

## Migration from Old System

Your old `scripts/nix/env/` files are preserved for reference, but the new system makes them redundant. The new approach offers:

1. **Better organization**: All configurations in one file
2. **Reduced duplication**: Shared modules instead of repeated code
3. **Enhanced functionality**: More powerful environment compositions
4. **Easier maintenance**: Single file to update instead of many

## Advanced Usage

You can also extend environments by creating your own flake that imports this one:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    dev-envs.url = "path:/home/username/.dotfiles/nix/envs";
  };

  outputs = { self, nixpkgs, flake-utils, dev-envs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        baseEnv = dev-envs.devShells.${system}.rust;
      in
      {
        devShells.custom-rust = pkgs.mkShell {
          inputsFrom = [ baseEnv ];
          buildInputs = baseEnv.buildInputs ++ [ pkgs.specific-package ];
        };
      });
}
```

## Troubleshooting

If you encounter issues:

1. Make sure you have Nix with flakes enabled
2. Verify that direnv is installed and working
3. Check that jq is available for the selection script
4. Ensure experimental features `nix-command` and `flakes` are enabled