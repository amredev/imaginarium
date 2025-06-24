#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/junegunn/fzf/releases/download/v$version"

stem="fzf-$version-linux_$(arch amd64 arm64)"

dir=$(download_and_decompress "$base_url/$stem.tar.gz")

move_to_path "$dir/fzf"
