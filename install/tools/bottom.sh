#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

deb="bottom_$version-1_$(arch amd64 arm64).deb"

download_and_install_deb "https://github.com/ClementTsang/bottom/releases/download/$version/$deb"
