#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.local/bin"

arch="$(uname -m)"
case "$arch" in
  x86_64) zellij_arch="x86_64"; lazydocker_arch="x86_64" ;;
  aarch64|arm64) zellij_arch="aarch64"; lazydocker_arch="arm64" ;;
  *)
    echo "run_once_10-localbin-tools.sh: unsupported arch: $arch; skipping."
    exit 0
    ;;
esac

install_zellij() {
  local want="0.43.1"
  if command -v zellij >/dev/null 2>&1; then
    local have
    have="$(zellij --version 2>/dev/null | awk '{print $2}' || true)"
    if [ "$have" = "$want" ]; then
      return 0
    fi
  fi

  local tmp
  tmp="$(mktemp -d)"

  local url="https://github.com/zellij-org/zellij/releases/download/v${want}/zellij-${zellij_arch}-unknown-linux-musl.tar.gz"
  curl -fsSL "$url" -o "$tmp/zellij.tgz"
  tar -C "$tmp" -xzf "$tmp/zellij.tgz"
  install -m 0755 "$tmp/zellij" "$HOME/.local/bin/zellij"
  rm -rf "$tmp"
}

install_lazydocker() {
  local want="0.24.4"
  if command -v lazydocker >/dev/null 2>&1; then
    local have
    have="$(lazydocker --version 2>/dev/null | awk '{print $2}' || true)"
    if [ "$have" = "$want" ]; then
      return 0
    fi
  fi

  local tmp
  tmp="$(mktemp -d)"

  local url="https://github.com/jesseduffield/lazydocker/releases/download/v${want}/lazydocker_${want}_Linux_${lazydocker_arch}.tar.gz"
  curl -fsSL "$url" -o "$tmp/lazydocker.tgz"
  tar -C "$tmp" -xzf "$tmp/lazydocker.tgz"
  install -m 0755 "$tmp/lazydocker" "$HOME/.local/bin/lazydocker"
  rm -rf "$tmp"
}

install_zellij
install_lazydocker
