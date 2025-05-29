FROM debian:trixie-slim

ARG USER=amredev

ENV HOME=/home/$USER

ARG INSTALL_SH=devcontainer-base/install.sh
RUN --mount=source=amrebash,target=amrebash \
  --mount=source=$INSTALL_SH,target=$INSTALL_SH $INSTALL_SH

USER $USER

RUN mkdir $HOME/devcontainer-hooks

COPY --chown=$USER:$USER amrebash $HOME/amrebash

ARG OMZ_SH=devcontainer-base/oh-my-zsh.sh
RUN --mount=source=$OMZ_SH,target=$OMZ_SH $OMZ_SH

COPY --chown=$USER:$USER ./devcontainer-base/.zshrc "$HOME"
COPY --chown=$USER:$USER ./devcontainer-base/bottom.toml "$HOME/.config/bottom/bottom.toml"

# The directory `$HOME/persisted` should be mounted as a volume to persist its
# contents across container restarts. It's used to store the shell history and
# some tool-specific caches.
RUN mkdir -p "$HOME/persisted" && \
  # The directory is for storing custom tools that should be in PATHs
  mkdir -p "$HOME/.tools"

ENV PATH="$HOME/.tools:$PATH"

ENTRYPOINT [ "bash", "-c", "$HOME/amrebash/container/init.sh \"$@\"", "--" ]

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
