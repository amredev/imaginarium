#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/crate-ci/typos/releases/download/v$version"

stem="typos-v$version-$(arch x86_64 aarch64)-unknown-linux-musl"

dir=$(download_and_decompress "$base_url/$stem.tar.gz")

move_to_path "$dir/typos"
