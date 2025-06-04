#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/utils/lib.sh"

step ./amrebash/install/node.sh 20.19.2
step ./amrebash/install/rust.sh 1.87.0 --target wasm32-unknown-unknown
step ./amrebash/install/taplo.sh 0.10.0
step ./amrebash/install/typos.sh 1.32.0

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends --no-install-suggests \
    build-essential \
    pkg-config \
    libssl-dev

# Builds from source, requires Rust toolchain
step ./amrebash/install/cargo-component.sh 0.3.0

sudo rm -rf /var/lib/apt/lists/*
step rm -rf "$HOME/.cargo/registry"
step rm -rf "$HOME/.cargo/git"
