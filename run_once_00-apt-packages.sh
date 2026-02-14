#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "run_once_00-apt-packages.sh: apt-get not found; skipping."
  exit 0
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "run_once_00-apt-packages.sh: sudo not found; skipping."
  exit 0
fi

# Keep this list small and focused on what ~/.zshrc expects.
pkgs=(
  ca-certificates
  curl
  direnv
  fd-find
  fzf
  gh
  git
  jq
  ripgrep
  rsync
  tmux
  unzip
  zip
  zoxide
  zsh
)

sudo apt-get update -y
sudo apt-get install -y "${pkgs[@]}"

mkdir -p "$HOME/.local/bin"

# Ubuntu ships fd as fdfind.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
