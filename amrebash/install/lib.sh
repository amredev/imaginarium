#!/usr/bin/env bash

. "$(dirname "${BASH_SOURCE[0]}")/../lib.sh"

# Get a Rust-style arch name, e.g. x86_64, aarch64, etc.
arch_rust=$(uname -m | sed "s/arm64/aarch64/")
export arch_rust

arch_go=$(uname -m | sed "s/x86_64/amd64/" | sed "s/arm64/aarch64/")
export arch_go

version=$1
export version

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
    tmp="/tmp/tools/$archive"

    step mkdir -p "$tmp"

    # Switch to the temporary directory. All file operations must be placed
    # after this command.
    pushd "$tmp" >/dev/null

    fetch "$url" --remote-name

    # Check the hash of the downloaded file if it was requested
    if [[ "$hash_algo" != "" ]]; then
        local hash
        hash=$(fetch "$url.$hash_algo")
        echo "$hash $archive" | step "${hash_algo}sum" --check
    fi

    if [[ $url == *.tar.* || $url == *.tgz ]]; then
        step tar --extract --file "$archive" "$@"
    elif [[ $url == *.gz ]]; then
        step gzip --decompress --stdout "$archive" >"$(basename "$url" .gz)"
    elif [[ $url == *.zip ]]; then
        step unzip "$archive" "$@"
    else
        echo "Unknown file type: $url"
        exit 1
    fi

    step rm "$archive"

    info "Decompressed: $(ls -lah --color=always)"

    # Return to the original directory. Must be the last command in the function.
    popd >/dev/null

    echo "$tmp"
}

function move_to_path {
    local tool_path="$1"
    local tool_name="${2:-$(basename "$tool_path")}"
    local out_dir="$HOME/.tools"

    step mkdir -p "$out_dir"
    step chmod +x "$tool_path"
    step mv "$tool_path" "$out_dir/$tool_name"

    # Sanity check: ensure the tool is executable
    step "$tool_name" --version
}

# Clean up the temp directory on exit
function cleanup {
    step rm -rf /tmp/tools
}

trap cleanup EXIT
