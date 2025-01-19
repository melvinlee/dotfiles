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


## References

### Official Documentation
- [Nix Package Manager](https://nixos.org/manual/nix/stable/)
- [Nix-Darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

### Community Resources
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)

### Tutorials & Guides
- [Getting started with Nix on MacOS](https://nixcademy.com/2024/01/15/nix-on-macos/)
- [macOS Setup Guide](https://sourabhbajaj.com/mac-setup/)
- [Declarative macOS Configuration](https://xyno.space/post/nix-darwin-introduction)

### Troubleshooting
- [Common Issues](https://github.com/LnL7/nix-darwin/wiki/Troubleshooting)
- [Nix Learn](https://nix.dev/)