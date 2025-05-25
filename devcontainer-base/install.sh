#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/lib.sh"

function apt-get-update-and-install {
    step apt-get update -y
    step apt-get install -y --no-install-recommends --no-install-suggests "$@"
}

apt-get-update-and-install sudo adduser

# The UID of 1000 is the default for most Linux distributions, which should make
# this user map to the default user on the host system for bind-mounted volumes.
#
# However, if the host user has a different UID, we'll need to update the user
# ID and file ownership in the image that is built on top of this one.
step adduser "$USER" --shell /bin/zsh --disabled-password \

# Allow paswordless sudo for the non-root user
echo "$USER ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USER"

packages=(
    # Better version of `cat` that adds syntax highlighting
    bat
    # SSL certificates
    ca-certificates
    # Terminal HTTP client
    curl
    # Source control
    git
    # Required for git ssh auth
    openssh-client
    unzip
    xz-utils
    # Better terminal experience
    zsh
)

apt-get-update-and-install "${packages[@]}"

info "=== Setting up bat ==="

# Bat has a name clash with some other package, so it's named `batcat` in Debian.
# The docs recommend making a symlink to fix this.
step ln -s /usr/bin/batcat /usr/local/bin/bat

# Fzf provides better search history navigation via Ctrl+R
info "=== Installing fzf ==="

# Not using the fzf via `apt` because it is too old on Debian 12 that oh-my-zsh
# fzf plugin fails with it on missing files. We can switch to apt in Debian 13
step git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
step "$HOME/.fzf/install"

# Utility for JSON/YAML/TOML processing
info "=== Installing yq ==="

yq_version=v4.45.4

fetch https://github.com/mikefarah/yq/releases/download/${yq_version}/yq_linux_amd64.tar.gz -O
tar -xf yq_linux_amd64.tar.gz
rm yq_linux_amd64.tar.gz
mv yq_linux_amd64 /usr/local/bin/yq

# Resource monitor and process manager
info "=== Installing bottom ==="

bottom_version="0.10.2"

fetch -O "https://github.com/ClementTsang/bottom/releases/download/$bottom_version/bottom_$bottom_version-1_amd64.deb"
dpkg -i "bottom_$bottom_version-1_amd64.deb"
rm "bottom_$bottom_version-1_amd64.deb"

info "=== Installing docker ==="

step apt-get update
step apt-get install ca-certificates curl
step install -m 0755 -d /etc/apt/keyrings
fetch https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
step chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  step tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get-update-and-install \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin

rm -rf /var/lib/apt/lists/*
