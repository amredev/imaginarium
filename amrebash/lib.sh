#!/usr/bin/env bash
# This file is meant to be sourced by other scripts, not executed directly.
# It contains a bunch of helper functions for writing bash scripts.

. "$(dirname "${BASH_SOURCE[0]}")/log.sh"
. "$(dirname "${BASH_SOURCE[0]}")/signal.sh"

# Retry a command a with backoff.
#
# The retry count is given by ATTEMPTS (default 5), the
# initial backoff timeout is given by TIMEOUT in seconds
# (default 1.)
#
# Successive backoffs double the timeout.
#
# Beware of set -e killing your whole script!
#
# Shamelessly copied from https://coderwall.com/p/--eiqg/exponential-backoff-in-bash
function with_backoff {
    local max_attempts=${ATTEMPTS-5}
    local timeout=${TIMEOUT-1}
    local attempt=0
    local exit_code=0

    while [[ $attempt -lt $max_attempts ]]
    do
        if [[ $attempt == 0 ]]; then
            start_group "${@}"
        else
            start_group "[Try $((attempt + 1))/$max_attempts] ${*}"
        fi

        # Temporarily disable the "exit script on error" behavior
        set +o errexit

        "$@"
        exit_code=$?

        # put exit on error back up
        set -o errexit

        end_group

        if [[ $exit_code == 0 ]]; then
            break
        fi

        warn "Failure! Retrying in $timeout seconds.."
        sleep "$timeout"
        attempt=$(( attempt + 1 ))
        timeout=$(( timeout * 2 ))
    done

    if [[ $exit_code != 0 ]]; then
        error "Giving up on retries (exit code $exit_code) ($*)"
    fi

    return $exit_code
}

# A generic step of execution in the script that should be logged,
# and also forward signals to the child process
function step {
    # forward_signals spawns a background process. We want `with_log` in that
    # process to be replaced with the invoked command so that it receives the
    # signals directly.
    forward_signals with_log exec "$@"
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
