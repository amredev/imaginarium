#!/usr/bin/env bash

set -euxo pipefail

# `curl` wrapper with better defaults
function fetch {
  curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --retry 5 \
    --retry-all-errors \
    "$@"
}

fetch https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

function install_plugin {
    local repo="$1"
    local plugin="${2:-$(basename "$repo")}"
    git clone --depth 1 --branch master "$repo.git" "$HOME/.oh-my-zsh/custom/plugins/$plugin"
}

install_plugin https://github.com/popstas/zsh-command-time command-time
install_plugin https://github.com/zsh-users/zsh-syntax-highlighting
install_plugin https://github.com/zsh-users/zsh-autosuggestions
