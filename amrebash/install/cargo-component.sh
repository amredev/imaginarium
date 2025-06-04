#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# The are no precompiled binaries for the latest release at the time of this
# writing. See: https://github.com/bytecodealliance/cargo-component/issues/397
cargo install cargo-component --locked --version "$version" --color always
