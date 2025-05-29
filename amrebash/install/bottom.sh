#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

step mkdir -p /tmp/tools/bottom
cd /tmp/tools

deb="bottom_$version-1_amd64.deb"

fetch -O "https://github.com/ClementTsang/bottom/releases/download/$version/$deb"
step dpkg -i "$deb"
step rm "$deb"
