#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/lib.sh"

install="$(dirname "${BASH_SOURCE[0]}")/../amrebash/install"

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
step adduser "$USER" --shell /bin/zsh --disabled-password

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

# Bat has a name clash with some other package, so it's named `batcat` in Debian.
# The docs recommend making a symlink to fix this.
step ln -s /usr/bin/batcat /usr/local/bin/bat

# Directory for tools downloaded directly by scripts
mkdir "$HOME/.tools"

# Fzf provides better search history navigation via Ctrl+R
"$install/fzf.sh" 0.62.0

# Utility for JSON/YAML/TOML processing
"$install/yq.sh" 4.45.4

# Resource monitor and process manager
"$install/bottom.sh" 0.10.2

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

# The directory `$HOME/persisted` should be mounted as a volume to persist its
# contents across container restarts. It's used to store the shell history and
# some tool-specific caches.
step mkdir "$HOME/persisted"

# Directory for custom scripts invoked at the container startup
step mkdir "$HOME/devcontainer-hooks"

step chown -R "$USER:$USER" "$HOME/persisted" "$HOME/devcontainer-hooks" "$HOME/.tools"

rm -rf /var/lib/apt/lists/*
