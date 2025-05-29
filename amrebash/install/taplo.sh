#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

version=$1

base_url=https://github.com/tamasfe/taplo/releases/download/$version

file_stem="taplo-linux-$arch_rust"

dir=$(download_and_decompress "$base_url/$file_stem.gz")

move_to_path "$dir/$file_stem" taplo
