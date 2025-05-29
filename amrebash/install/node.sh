#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

case "$arch_rust" in
    x86_64) arch="x64" ;;
    aarch64) arch="arm64" ;;
    *) echo "Unsupported architecture: $arch_rust"; exit 1 ;;
esac

stem="node-v$version-linux-$arch"

dir=$(download_and_decompress "https://nodejs.org/dist/v$version/$stem.tar.xz")

step mv "$dir/$stem" "$HOME/.node"
