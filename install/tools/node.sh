#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

case $(os) in
    linux)   ext=tar.gz ; os=linux ;;
    darwin)  ext=tar.gz ; os=darwin ;;
    windows) ext=zip;     os=win ;;
    *)
        bail "Unsupported OS: $os"
        ;;
esac

stem="node-v$version-$os-$(arch x64 arm64)"

dir=$(download_and_decompress "https://nodejs.org/dist/v$version/$stem.$ext")

step mv "$dir/$stem" "$HOME/.node"
