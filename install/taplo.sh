#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/tamasfe/taplo/releases/download/$version"

stem="taplo-$(os)-$(arch x86_64 aarch64)"

dir=$(download_and_decompress "$base_url/$stem.gz")

move_to_path "$dir/$stem" taplo
