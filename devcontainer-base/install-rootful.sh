#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../scripts/utils/lib.sh"

packages=(
    adduser
    # SSL certificates
    ca-certificates
    # Terminal HTTP client
    curl
    # Source control
    git
    # Required for git ssh auth
    openssh-client
    sudo
    unzip
    xz-utils
    # Better terminal experience
    zsh
)

step apt-get update -y
step apt-get install -y --no-install-recommends --no-install-suggests "${packages[@]}"

# The UID of 1000 is the default for most Linux distributions, which should make
# this user map to the default user on the host system for bind-mounted volumes.
#
# However, if the host user has a different UID, we'll need to update the user
# ID and file ownership in the image that is built on top of this one.
#
# `--gecos` is used to silence the prompt for user information.
step adduser "$USER" --shell /bin/zsh --disabled-password --gecos

# Allow paswordless sudo for the non-root user
step echo "$USER ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/$USER"

# Reduce image size a bit by removing unnecessary files
step rm -rf /var/lib/apt/lists/*
