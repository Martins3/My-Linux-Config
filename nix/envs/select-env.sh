#!/usr/bin/env bash
set -E -e -u -o pipefail

# New improved script for selecting and activating Nix development environments
PROGDIR=$(readlink -m "$(dirname "$0")")

# Function to list available devShells from the flake
list_devshells() {
  nix flake show "${PROGDIR}/flake.nix" --json 2>/dev/null | jq -r '.devShells | to_entries[] | .key'
}

# Get available devShells from the flake
echo "Fetching available development environments..."
items=()
while IFS= read -r line; do
    items+=("$line")
done < <(list_devshells 2>/dev/null || echo -e "default\ncc\nrust\nllvm")

if [ ${#items[@]} -eq 0 ]; then
    echo "No development environments found. Using default."
    selected_shell="default"
else
    selected_shell=$(printf "%s\n" "${items[@]}" | fzf --prompt="Select development environment: ")
fi

if [ -z "$selected_shell" ]; then
    echo "No environment selected, exiting."
    exit 1
fi

echo "Selected environment: $selected_shell"

# Create a symlink to the flake file and let direnv handle it through .envrc
# First, remove any existing dev-shell.nix
rm -f dev-shell.nix

# Create a dev shell file that references the selected environment
cat > dev-shell.nix << EOF
let
  flake = builtins.getFlake "${PROGDIR}/flake.nix";
  system = builtins.currentSystem;
in
flake.devShells.\${system}.${selected_shell}
EOF

# Update .envrc to use the dev shell
if [ -f .envrc ]; then
  # Remove old nix directive if it exists
  sed -i '/use nix/d' .envrc
fi

# Add the new nix development shell directive to .envrc
echo "use nix shell --experimental-features 'nix-command flakes' -f dev-shell.nix" >> .envrc
direnv allow

echo "Environment set up for $selected_shell. Run 'direnv reload' or cd out and back in to activate."