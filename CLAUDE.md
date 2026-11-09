# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Apply Configuration

```bash
# Install packages listed in launch-package.yml (installs Homebrew if missing)
./launch.sh

# Also run `brew update` and upgrade already-installed packages
./launch.sh --upgrade

# Symlink dotfiles to ~ using GNU Stow (run from repo root)
stow .
```

## Architecture

- **`launch.sh`** — Bootstrap script. Parses `launch-package.yml` with python3 and runs `brew install` / `brew install --cask` for each entry, skipping ones already installed. `--upgrade` upgrades installed packages; an optional positional arg points to a different package file.
- **`launch-package.yml`** — Package list. `packages:` = Homebrew formulae, `cask:` = Homebrew casks.
- **`.zshrc`** — Shell config managed by **GNU Stow**, symlinked to `~/`.
- **`archive/nix-darwin/`** — Retired nix-darwin + Home Manager config. No longer used; kept for reference only. Do not add packages here.

## Package Placement Convention

| Where to add | When |
|---|---|
| `launch-package.yml` → `packages` | CLI tools (Homebrew formulae, including `tap/name` formulae) |
| `launch-package.yml` → `cask` | macOS GUI applications |

## Key Details

- Target host platform: Apple Silicon macOS
- User home directory: `/Volumes/SSD/melvinlee` (non-standard, on external SSD)
- Stow target is `~/` and ignores `.stowrc`, `archive/`, `.claude/`, `launch.*`, and `.pre-commit-config.yaml`
- A gitleaks pre-commit hook scans staged changes for secrets (`.pre-commit-config.yaml`). After cloning, run `pre-commit install` to enable it
