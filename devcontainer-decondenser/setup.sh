#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/utils/lib.sh"

packages=(
    # Required as linker
    clang
)

step sudo apt-get update -y
step sudo apt-get install -y --no-install-recommends --no-install-suggests "${packages[@]}"

step ./amrebash/install/node.sh 20.19.2
step ./amrebash/install/rust.sh 1.87.0 --target wasm32-wasip2
step ./amrebash/install/mold.sh 2.40.0
step ./amrebash/install/taplo.sh 0.10.0
step ./amrebash/install/typos.sh 1.32.0

step sudo rm -rf /var/lib/apt/lists/*
