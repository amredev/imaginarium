#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

base_url="https://github.com/bytecodealliance/cargo-component/releases/download/$version"

stem="cargo-component-$(arch x86_64 aarch64)-unknown-linux-gnu"

fetch "$base_url/$stem" > cargo-component

move_to_path cargo-component
