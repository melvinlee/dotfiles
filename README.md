# dotfiles

```sh
# Install with stow:
stow .
```

## Nix Darwin Configuration

## Prerequisites
- macOS 10.15 or later
- Administrative privileges

## Installation Steps

### Install Nix Package Manager
```bash
sh <(curl -L https://nixos.org/nix/install)
```

### Install Nix-Darwin
```sh
cd /nix-darwin

# Initialize flake
nix flake init -t nix-darwin

# Build initial configuration
nix build .#mini

# Create first generation
darwin-rebuild switch --flake .#mini
```