#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

deb=bat_${version}_$(arch amd64 arm64).deb

download_and_install_deb "https://github.com/sharkdp/bat/releases/download/v$version/$deb"
