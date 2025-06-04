#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/utils/lib.sh"

step ./amrebash/install/node.sh 20.19.2
step ./amrebash/install/rust.sh 1.87.0 --target wasm32-wasip2
step ./amrebash/install/mold.sh 2.40.0
step ./amrebash/install/taplo.sh 0.10.0
step ./amrebash/install/typos.sh 1.32.0
