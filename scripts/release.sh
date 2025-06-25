#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/utils/lib.sh"

bump="${1:-minor}"

step git push
step git fetch --tags

version=$(git tag -l 'v*.*.*' | sort --version-sort | tail --lines 1)

if [[ -z "$version" ]]; then
    info "No semver tag found (vX.Y.Z). Starting at v0.1.0"
    major=0
    minor=0
    patch=0
else
    IFS='.' read -r major minor patch <<<"${version#v}"
fi

case "$bump" in
    major)
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    minor)
        minor=$((minor + 1))
        patch=0
        ;;
    patch)
        patch=$((patch + 1))
        ;;
    *)
        bail "Invalid bump: '$bump' (must by any of major, minor, or patch)"
        ;;
esac

new_version="v${major}.${minor}.${patch}"

step git tag "$new_version"
git push --tags
