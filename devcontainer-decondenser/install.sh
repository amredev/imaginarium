#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/lib.sh"

node_version="20.19.2"

mkdir -p "$HOME/.node"

# Download and install nvm:
fetch https://nodejs.org/dist/v$node_version/node-v$node_version-linux-x64.tar.xz | \
    step tar -xJf - -C "$HOME/.node" --strip-components=1
