# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Apply Configuration

```bash
# Apply full nix-darwin + Home Manager configuration
darwin-rebuild switch --flake ./nix-darwin#mini

# Apply Home Manager only (faster, no sudo needed)
home-manager switch

# Symlink dotfiles to ~ using GNU Stow (run from repo root)
stow .
```

## Architecture

This repo uses **two parallel systems** that must stay in sync:

- **`nix-darwin/flake.nix`** — System-level config: Homebrew casks/brews, macOS system defaults, spacebar status bar, and nix-darwin settings. Rebuild requires `darwin-rebuild switch`.
- **`nix-darwin/home.nix`** — User-level packages managed by Home Manager. Focused on DevOps/Kubernetes tooling. Rebuild via `home-manager switch` or `darwin-rebuild switch`.
- **`.zshrc`** — Shell config managed by **GNU Stow** (not Home Manager). `programs.zsh.enable` in home.nix is intentionally disabled to avoid conflict. Stow symlinks `.zshrc` to `~/`.

The hostname used in the flake is `mini` (see `darwinConfigurations."mini"`).

## Package Placement Convention

| Where to add | When |
|---|---|
| `flake.nix` → `environment.systemPackages` | System-wide CLI tools needed before login |
| `flake.nix` → `homebrew.brews` | Tools only available via Homebrew (no Nix package) |
| `flake.nix` → `homebrew.casks` | macOS GUI applications |
| `home.nix` → `home.packages` | User-specific CLI tools (most things go here) |

## Key Details

- Target host platform: `aarch64-darwin` (Apple Silicon)
- User home directory: `/Volumes/SSD/melvinlee` (non-standard, on external SSD)
- Stow target is `~/` and explicitly ignores `nix-darwin/` and `.stowrc`
- `homebrew.onActivation.cleanup = "zap"` — packages not listed will be **removed** on rebuild
- `nixpkgs-unstable` channel is used (bleeding edge packages)
