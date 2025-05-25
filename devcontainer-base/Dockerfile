FROM debian:trixie-slim

ENV USER=amredev
ENV HOME=/home/$USER

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=source=scripts/utils,target=scripts/utils \
    --mount=source=devcontainer-base/install-rootful.sh,target=devcontainer-base/install-rootful.sh \
    ./devcontainer-base/install-rootful.sh

USER $USER

# This directory is for storing custom tools that should be in PATH
ENV PATH="$HOME/tools:$PATH"

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=source=scripts/utils,target=scripts/utils \
    --mount=source=install/tools,target=install/tools \
    --mount=source=devcontainer-base/install-rootless.sh,target=devcontainer-base/install-rootless.sh \
    ./devcontainer-base/install-rootless.sh

COPY --chown=$USER:$USER scripts $HOME/scripts
COPY --chown=$USER:$USER ./devcontainer-base/.zshrc "$HOME"
COPY --chown=$USER:$USER ./devcontainer-base/bottom.toml "$HOME/.config/bottom/bottom.toml"

ENTRYPOINT [ "bash", "-c", "$HOME/scripts/init-container.sh \"$@\"", "--" ]

# Make sure the container stays alive
CMD [ "sleep", "infinity" ]

# Check for the presence of a special marker file that indicates that the
# container has been initialized. Use a big `--interval` to "disable"
# healthchecks after initialization completes.
#
# Also, don't be fooled - docker dosn't interpolate env vars in the CMD exec
# form, so we explicitly use `bash -c` to expand the `$HOME` variable.
HEALTHCHECK --start-period=10s --start-interval=0.5s --retries=1 --interval=9999h \
    CMD [ "bash", "-c", "test -f $HOME/.initialized" ]
