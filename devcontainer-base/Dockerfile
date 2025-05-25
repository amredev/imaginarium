FROM alpine:3.21

RUN apk add --no-cache \
    # Shell interpreter
    bash \
    # Better version of `cat` that adds syntax highlighting
    bat \
    # Resource monitor and process manager
    bottom \
    # Terminal HTTP client
    curl \
    # Source control
    git \
    # Fzf provides better search history navigation via Ctrl+R
    fzf \
    # JSON processing in the terminal/scripts
    jq \
    # Required for git ssh auth
    openssh-client \
    # Run commands as root
    sudo \
    # Better terminal experience
    zsh \
    # Install packages from the Alpine edge repository
    && apk add --repository https://dl-cdn.alpinelinux.org/alpine/edge/community \
    # The latest version of `docker-compose` in the `edge` repo contains a fix
    # for the following annoying terminal flickering bug:
    # https://github.com/docker/compose/issues/12370
    #
    # TODO: switch this to the main repo once it has v2.35.1+ docker-compose
    docker-cli-compose

ARG USER=amredev

# The UID of 1000 is the default for most Linux distributions, which should make
# this user map to the default user on the host system for bind-mounted volumes.
#
# However, if the host user has a different UID, we'll need to update the user
# ID and file ownership in the image that is built on top of this one.
RUN adduser "$USER" --uid 1000 --shell /bin/zsh --disabled-password \
    # Allow paswordless sudo for the non-root user
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USER"

USER $USER

ENV HOME=/home/$USER

# Path where the workspace should be mounted.
ENV CONTAINER_WORKSPACE=$HOME/workspace

RUN mkdir -p "$CONTAINER_WORKSPACE"

COPY --chown=$USER:$USER amrebash $HOME/amrebash

ARG OMZ=devcontainer-base/oh-my-zsh.sh
RUN --mount=source=$OMZ,target=$OMZ $OMZ

COPY --chown=$USER:$USER ./devcontainer-base/.zshrc "$HOME"
COPY --chown=$USER:$USER ./devcontainer-base/bottom.toml "$HOME/.config/bottom"

# These two scripts can be used to customize the shell environment. They are
# sourced before and after `oh-my-zsh` in the `.zshrc` file.
RUN ln -s "$CONTAINER_WORKSPACE/.devcontainer/.zshrc.custom.pre.sh" "$HOME/.zshrc.custom.pre.sh"
RUN ln -s "$CONTAINER_WORKSPACE/.devcontainer/.zshrc.custom.post.sh" "$HOME/.zshrc.custom.post.sh"

# The directory `$HOME/persisted` should be mounted as a volume to persist its
# contents across container restarts. It's used to store the shell history and
# some tool-specific caches.
RUN mkdir -p "$HOME/persisted"

WORKDIR "$CONTAINER_WORKSPACE"

ENTRYPOINT [ "../amrebash/container/init.sh" ]

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
