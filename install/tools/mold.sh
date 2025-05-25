#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/rui314/mold/releases/download/v$version"

stem="mold-$version-$(arch x86_64 aarch64)-linux"

dir=$(download_and_decompress "$base_url/$stem.tar.gz")

move_to_path "$dir/$stem/bin/mold"
