#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

version=$1

base_url=https://github.com/crate-ci/typos/releases/download/v$version

file_stem="typos-v$version-$arch_rust-unknown-linux-musl"

dir=$(download_and_decompress "$base_url/$file_stem.tar.gz")

move_to_path "$dir/typos"
