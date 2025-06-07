#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../scripts/utils/lib.sh"

packages=(
    # Required as a linker
    clang
)

step sudo apt-get update -y
step sudo apt-get install -y --no-install-recommends --no-install-suggests "${packages[@]}"

step ./scripts/install/mold.sh 2.40.0
step ./scripts/install/taplo.sh 0.10.0
step ./scripts/install/typos.sh 1.32.0

# We are using the `dev` version because at the time of this writing the latest
# released version lacks binary artifacts, and we don't want to expload the
# build time by compiling this tool from source. Hopefully, the lack of precompiled
# binaries will be fixed soon:
# https://github.com/bytecodealliance/cargo-component/issues/397
step ./scripts/install/cargo-component.sh dev

step ./scripts/install/node.sh 20.19.2
step ./scripts/install/rust.sh 1.87.0 \
    --target wasm32-wasip1 \
    --target wasm32-unknown-unknown

step rm -rf "$HOME/.cargo/registry"
step rm -rf "$HOME/.cargo/git"
step sudo rm -rf /var/lib/apt/lists/*
