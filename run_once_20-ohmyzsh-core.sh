#!/usr/bin/env bash
set -euo pipefail

# We manage ~/.oh-my-zsh/custom with chezmoi, but the oh-my-zsh core repo itself
# should come from upstream so fresh hosts work immediately.

if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  exit 0
fi

if ! command -v git >/dev/null 2>&1; then
  echo "run_once_20-ohmyzsh-core.sh: git not found; skipping."
  exit 0
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "run_once_20-ohmyzsh-core.sh: rsync not found; skipping."
  exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$tmp/ohmyzsh"
mkdir -p "$HOME/.oh-my-zsh"

# Preserve any existing custom content that chezmoi may have already applied.
rsync -a --exclude 'custom/' "$tmp/ohmyzsh/" "$HOME/.oh-my-zsh/"

