#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/koalaman/shellcheck/releases/download/v$version"

os=$(os)

if [[ "$os" == "windows" ]]; then
    stem="shellcheck-v$version.zip"
else
    stem="shellcheck-v$version.$os.$(arch x86_64 aarch64)"
fi

dir=$(download_and_decompress "$base_url/$stem.tar.xz")

move_to_path "$dir/shellcheck-v$version/shellcheck"
