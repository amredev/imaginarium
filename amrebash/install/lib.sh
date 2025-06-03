#!/usr/bin/env bash

. "$(dirname "${BASH_SOURCE[0]}")/../utils/lib.sh"

# Get the current machine arch using the given architecture naming conventions.
function arch {
    local amd64="$1"
    local arm64="$2"
    local uname_output

    uname_output="$(uname -m)"

    case "$uname_output" in
        x86_64) echo "$amd64" ;;
        arm64) echo "$arm64" ;;
        *) echo "Unsupported architecture: $uname_output"; exit 1 ;;
    esac
}

version=${1:-"latest"}
export version

shift || true

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
