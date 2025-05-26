#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/lib.sh"

node_version="20.19.2"

mkdir -p "$HOME/.node"

# Download and install node:
fetch https://nodejs.org/dist/v$node_version/node-v$node_version-linux-x64.tar.xz \
    | step tar -xJf - -C "$HOME/.node" --strip-components=1


rust_version="1.87.0"

# Download and run `rustup-init.sh` (-y argument disables confirmation prompts)
# to install rust toolchain
fetch --proto '=https' --tlsv1.2 https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain $rust_version --no-modify-path
