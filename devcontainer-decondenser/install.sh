#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/lib.sh"

# Download and install nvm:
fetch https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
# shellcheck disable=SC1091
. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 20

# Small sanity check:
step node -v
step nvm current
step npm -v
