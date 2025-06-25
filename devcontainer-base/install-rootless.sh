#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../scripts/utils/lib.sh"

install="$(dirname "${BASH_SOURCE[0]}")/../install"

# Directory for tools downloaded directly by scripts
mkdir "$HOME/tools"

# Better version of `cat` that adds syntax highlighting
step "$install/bat.sh" 0.25.0

# Resource monitor and process manager
step "$install/bottom.sh" 0.10.2

# Container runtime
step sudo "$install/docker.sh"

# Fzf provides better search history navigation via Ctrl+R
step "$install/fzf.sh" 0.62.0

# Benchmark CLI commands
step "$install/hyperfine.sh" 1.19.0

# Terminal ergonomics
step "$install/oh-my-zsh.sh"

# Utility for JSON/YAML/TOML processing
step "$install/yq.sh" 4.45.4

# This dir should be mounted as a volume to persist its contents across
# container restarts to save the user's shell history.
step mkdir -p "$HOME/shell-history"

# Directory for custom scripts invoked at the container startup
step mkdir "$HOME/devcontainer-hooks"

# Reduce image size a bit by removing unnecessary files
step sudo rm -rf /var/lib/apt/lists/*
step rm -rf /tmp/tools
