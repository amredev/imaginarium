#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

stem="node-v$version-linux-$(arch x64 arm64)"

dir=$(download_and_decompress "https://nodejs.org/dist/v$version/$stem.tar.xz")

step mv "$dir/$stem" "$HOME/.node"
