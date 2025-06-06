#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/utils/lib.sh"

step mkdir -p "$CONTAINER_WORKSPACE"

# These two scripts can be used to customize the shell environment. They are
# sourced before and after `oh-my-zsh` in the `.zshrc` file.
step ln -s "$CONTAINER_WORKSPACE/.devcontainer/.zshrc.custom.pre.sh" "$HOME/.zshrc.custom.pre.sh"
step ln -s "$CONTAINER_WORKSPACE/.devcontainer/.zshrc.custom.post.sh" "$HOME/.zshrc.custom.post.sh"
