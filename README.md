# Dotfiles Configuration

[![Nix Version](https://img.shields.io/badge/Nix-2.19-blue.svg)](https://nixos.org)
[![Darwin Version](https://img.shields.io/badge/Darwin-23.0.0-blue.svg)](https://github.com/LnL7/nix-darwin)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Introduction
This repository contains my personal dotfiles and system configuration for macOS using Nix and Nix-Darwin.

## Features
- System-wide package management with Nix
- Declarative system configuration with Nix-Darwin
- Home directory configuration with Home Manager
- Git configuration management
- Shell environment setup

## Prerequisites
### System Requirements
- macOS 10.15 (Catalina) or later
- Administrative privileges
- Xcode Command Line Tools installed

### Required Tools
- [Nix Package Manager](https://nixos.org/download.html)
- [Nix-Darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://github.com/nix-community/home-manager)

## Installation Steps
### Install Nix Package Manager
```bash
# Install Nix using Nix installer from Determinate Systems
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install

# To verify that Nix has been installed successfully,
nix-shell -p neofetch --run neofetch
```

### Install Nix-Darwin
```sh
cd /nix-darwin

# Build initial configuration
nix run nix-darwin -- switch --flake .#mini

# Create first generation
darwin-rebuild switch --flake .#mini
```

## Configuration
The configuration is organized into the following directories:

- `nix-darwin/`: System configuration using Nix-Darwin

## Troubleshooting
Common issues and solutions:

1. **Permission errors**: Run commands with `sudo` when necessary
2. **Broken packages**: Try running `nix-collect-garbage -d` to clean up old packages

## References
### Official Documentation
- [Nix Package Manager](https://nixos.org/manual/nix/stable/)
- [Nix-Darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://nix-community.github.io/home-manager/)

### Community Resources
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)

### Tutorials & Guides
- [Getting started with Nix on MacOS](https://nixcademy.com/2024/01/15/nix-on-macos/)
- [Declarative macOS Configuration](https://xyno.space/post/nix-darwin-introduction)
