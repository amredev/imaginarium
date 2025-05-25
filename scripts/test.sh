#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/utils/lib.sh"

image="$1"

tag=ghcr.io/amredev/$image:latest

step docker buildx bake --load --set "$image.tags=$tag" --progress plain "$image"

exec docker run -it --rm --name "$image-test" "$tag" zsh
