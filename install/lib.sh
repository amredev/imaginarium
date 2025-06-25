#!/usr/bin/env bash

set -euo pipefail

. "$(dirname "${BASH_SOURCE[0]}")/../scripts/utils/lib.sh"

info "Running in shell: $SHELL ($BASH_VERSION)"

version=${1:-"latest"}
export version

shift || true

# Add a dir to path if running in a CI environment. Otherwise, it's not possible
# to extend the PATH of the parent process.
function add_to_path {
    local dir="$1"

    export PATH="$dir:$PATH"

    if [ -n "${CI+x}" ]; then
        step echo "$dir" >> "$GITHUB_PATH"
    fi
}

add_to_path "$HOME/tools"

# Get the current machine arch using the given architecture naming conventions.
function arch {
    local amd64="$1"
    local arm64="$2"
    local uname_output

    uname_output="$(uname -m)"

    case "$uname_output" in
        x86_64)  echo "$amd64" ;;

        # Yeah. On different platforms `uname -m` outputs different names for
        # the same architecture. This is a mess. For example on Ubuntu the
        # output is `aarch64`, but on macOS it is `arm64`.
        aarch64) echo "$arm64" ;;
        arm64)   echo "$arm64" ;;

        *) bail "Unsupported architecture: $uname_output" ;;
    esac
}

function os {
    case "$OSTYPE" in
        linux*)  echo linux ;;
        darwin*) echo darwin ;;
        msys)    echo windows ;;
        *) bail "Unknown OS: $OSTYPE" ;;
    esac
}

function triple_rust {
    arch=$(arch x86_64 aarch64)
    case $(os) in
        linux)   echo "$arch-unknown-linux-gnu" ;;
        darwin)  echo "$arch-apple-darwin" ;;
        windows) echo "$arch-pc-windows-msvc" ;;
        *) bail "Unsupported OS for Rust target triple: $(os)" ;;
    esac
}

function download_and_decompress {
    local hash_algo=""
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --check-hash)
                hash_algo="$2"
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done

    local url=$1
    shift

    local archive
    archive="$(basename "$url")"

    local tmp
    tmp="/tmp/tools/${archive%.*}"

    step mkdir -p "$tmp"

    # Switch to the temporary directory. All file operations must be placed
    # after this command.
    cd "$tmp"

    fetch "$url" --remote-name

    # Check the hash of the downloaded file if it was requested
    if [[ "$hash_algo" != "" ]]; then
        local hash
        hash=$(fetch "$url.$hash_algo")
        echo "$hash $archive" | step "${hash_algo}sum" --check >&2
    fi

    if [[ $url == *.tar.* || $url == *.tgz ]]; then
        step tar --extract --file "$archive" "$@"
    elif [[ $url == *.gz ]]; then
        step gzip --decompress --stdout "$archive" >"$(basename "$url" .gz)"
    elif [[ $url == *.zip ]]; then
        step unzip -u "$archive" "$@" >&2
    else
        echo "Unknown file type: $url"
        exit 1
    fi

    step rm "$archive"

    info "Decompressed: $(ls -lah --color=always)"

    echo "$tmp"
}

function download_and_install_deb {
    local url=$1

    local deb_file
    deb_file="$(basename "$url")"

    local tmp
    tmp="/tmp/tools/${deb_file%.*}"

    step mkdir -p "$tmp"

    cd "$tmp"

    fetch "$url" --remote-name

    step sudo dpkg -i "$deb_file"
}

function move_to_path {
    local tool_path="$1"
    local tool_name="${2:-$(basename "$tool_path")}"
    local out_dir="$HOME/tools"

    step mkdir -p "$out_dir"
    step chmod +x "$tool_path"
    step mv "$tool_path" "$out_dir/$tool_name"

    # Sanity check: ensure the tool is executable
    step "$tool_name" --version
}

# `curl` wrapper with better defaults
function fetch {
    step curl \
        --fail \
        --silent \
        --show-error \
        --location \
        --retry 5 \
        --retry-all-errors \
        "$@"
}
