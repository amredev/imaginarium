#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

step install -m 0755 -d /etc/apt/keyrings
fetch https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
step chmod a+r /etc/apt/keyrings/docker.asc

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    step tee /etc/apt/sources.list.d/docker.list >/dev/null

step apt-get update -y
step apt-get install -y --no-install-recommends --no-install-suggests \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin
