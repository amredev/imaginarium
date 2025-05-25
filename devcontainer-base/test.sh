#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../amrebash/lib.sh"

tag=ghcr.io/amrebash/devcontainer-base:latest

step docker buildx bake --load --set "devcontainer-base.tags=$tag" devcontainer-base

exec docker run -it --rm --name devcontainer-base-test $tag zsh
