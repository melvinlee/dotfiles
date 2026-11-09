#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_FILE="$SCRIPT_DIR/launch-package.yml"
UPGRADE=false

for arg in "$@"; do
  case "$arg" in
    --upgrade) UPGRADE=true ;;
    -*)
      echo "Unknown option: $arg" >&2
      echo "Usage: $0 [--upgrade] [apps-file]" >&2
      exit 1
      ;;
    *) APPS_FILE="$arg" ;;
  esac
done

if [[ ! -f "$APPS_FILE" ]]; then
  echo "Apps file not found: $APPS_FILE" >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$('/opt/homebrew/bin/brew' shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$('/usr/local/bin/brew' shellenv)"
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew installation failed or brew is still unavailable." >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to parse $APPS_FILE" >&2
  exit 1
fi

outdated_formulae=""
outdated_casks=""

if [[ "$UPGRADE" == true ]]; then
  brew update
  # Strip tap prefixes so names match `brew list --versions` output
  outdated_formulae="$(brew outdated --formula --quiet | sed 's#.*/##' || true)"
  outdated_casks="$(brew outdated --cask --quiet | sed 's#.*/##' || true)"
fi

# Usage: report_installed <formula|cask> <package>
# Prints the installed version and, with --upgrade, upgrades it only if outdated.
report_installed() {
  local kind="$1" pkg="$2" versions outdated
  versions="$(brew list "--$kind" --versions "${pkg##*/}")"

  if [[ "$UPGRADE" != true ]]; then
    echo "Already installed: $versions"
    return
  fi

  if [[ "$kind" == cask ]]; then outdated="$outdated_casks"; else outdated="$outdated_formulae"; fi

  if grep -qxF "${versions%% *}" <<< "$outdated"; then
    echo "Upgrading: $versions"
    if ! brew upgrade "--$kind" "$pkg"; then
      echo "Skipping failed upgrade: $pkg" >&2
    fi
  else
    echo "Up to date: $versions"
  fi
}

echo "Using app definition file: $APPS_FILE"
echo "Installing packages..."

commands=()
while IFS= read -r cmd; do
  commands+=("$cmd")
done < <(python3 - "$APPS_FILE" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
lines = path.read_text(encoding="utf-8").splitlines()
section = None

for raw in lines:
    line = raw.split("#", 1)[0].rstrip()
    if not line.strip():
        continue
    if re.match(r"^packages\s*:\s*$", line):
        section = "packages"
        continue
    if re.match(r"^cask\s*:\s*$", line):
        section = "cask"
        continue
    match = re.match(r"^\s*-\s*(.+?)\s*$", line)
    if match and section:
        item = match.group(1).strip().strip('"').strip("'")
        if section == "packages":
            print(f"brew install {item}")
        elif section == "cask":
            print(f"brew install --cask {item}")
PY
)

for cmd in "${commands[@]}"; do
  echo
  echo "→ $cmd"
  read -r -a command_parts <<< "$cmd"

  if [[ "${command_parts[0]}" == "brew" && "${command_parts[1]}" == "install" ]]; then
    if [[ "${command_parts[2]}" == "--cask" ]]; then
      pkg="${command_parts[3]}"
      if brew list --cask "$pkg" >/dev/null 2>&1; then
        report_installed cask "$pkg"
        continue
      fi
    else
      pkg="${command_parts[2]}"
      if brew list --formula "$pkg" >/dev/null 2>&1; then
        report_installed formula "$pkg"
        continue
      fi
    fi
  fi

  if output="$(${command_parts[@]} 2>&1)"; then
    printf '%s\n' "$output"
  else
    if echo "$output" | grep -qi 'already an App'; then
      echo "Skipped: ${pkg##*/} exists in /Applications but isn't managed by Homebrew (adopt with: brew install --cask --adopt $pkg)"
    elif echo "$output" | grep -Eqi 'already installed|already exists'; then
      echo "Already installed or skipped: $cmd"
    else
      printf '%s\n' "$output" >&2
      echo "Skipping failed command: $cmd" >&2
    fi
  fi
done

echo
printf 'Finished installing apps from %s\n' "$APPS_FILE"
