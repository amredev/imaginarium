#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/sharkdp/hyperfine/releases/download/v$version"

stem="hyperfine-v$version-$(arch x86_64 aarch64)-unknown-linux-gnu"

dir=$(download_and_decompress "$base_url/$stem.tar.gz")

move_to_path "$dir/$stem/hyperfine"
