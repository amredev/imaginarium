#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

fetch --proto '=https' --tlsv1.2 https://sh.rustup.rs | step sh -s -- \
    -y \
    --default-toolchain "$version" \
    --no-modify-path \
    --profile minimal \
    --component clippy \
    --component rustfmt \
    --component rust-src \
    "$@"
