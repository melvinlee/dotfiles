# Dotfiles Configuration

[![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon-000000?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Homebrew](https://img.shields.io/badge/Homebrew-FBB040?logo=homebrew&logoColor=black)](https://brew.sh)
[![Shell](https://img.shields.io/badge/Shell-zsh-89E051?logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Last Commit](https://img.shields.io/github/last-commit/melvinlee/dotfiles)](https://github.com/melvinlee/dotfiles/commits/main)

## Introduction
This repository contains my personal dotfiles and macOS setup. Packages are installed with Homebrew via `launch.sh`, and dotfiles are symlinked into `~` with GNU Stow.

## Features
- One-command package bootstrap from a YAML package list
- Optional upgrade of already-installed packages
- Dotfile management with GNU Stow
- Zsh shell environment setup

## Prerequisites
- macOS on Apple Silicon
- Xcode Command Line Tools (`xcode-select --install`)
- `python3` (used by `launch.sh` to parse the package list)

Homebrew is installed automatically by `launch.sh` if it is missing.

## Installation
### Install packages
```bash
# Install everything listed in launch-package.yml
./launch.sh

# Also update Homebrew and upgrade packages that are already installed
./launch.sh --upgrade

# Use a different package list
./launch.sh path/to/packages.yml
```

Edit `launch-package.yml` to add or remove packages:

```yaml
packages:   # Homebrew formulae
    - git
    - kubectl

cask:       # Homebrew casks (GUI apps)
    - google-chrome
```

### Symlink dotfiles
```bash
# Run from the repo root
stow .
```

## Repository Layout
| Path | Purpose |
|---|---|
| `launch.sh` | Installs Homebrew (if needed) and the packages in `launch-package.yml` |
| `launch-package.yml` | List of Homebrew formulae and casks to install |
| `.zshrc` | Zsh configuration, symlinked to `~` by Stow |
| `.stowrc` | Stow options (target `~`, ignored files) |
| `archive/nix-darwin/` | Retired nix-darwin + Home Manager configuration, kept for reference |

## Troubleshooting
1. **`command not found: launch.sh`**: run it as `./launch.sh` from the repo root.
2. **Permission denied**: `chmod +x launch.sh`.
3. **Stow conflicts**: remove or back up the existing file in `~` and re-run `stow .`.

## References
- [Homebrew](https://docs.brew.sh/)
- [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html)
