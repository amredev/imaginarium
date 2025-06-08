#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/bytecodealliance/cargo-component/releases/download/$version"

arch=$(arch x86_64 aarch64)

case $(os) in
    linux)   triple="$arch-unknown-linux-gnu" ;;
    darwin)  triple="$arch-apple-darwin" ;;
    windows) triple="$arch-pc-windows-gnu" ;;
    *)
esac

stem="cargo-component-$triple"

fetch "$base_url/$stem" > cargo-component

move_to_path cargo-component
