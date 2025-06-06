FROM amredev-devcontainer-base

ENV PATH="$HOME/.node/bin:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"

ENV CONTAINER_WORKSPACE=$HOME/dev/decondenser
WORKDIR $CONTAINER_WORKSPACE

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=source=scripts,target=scripts \
    --mount=source=devcontainer-decondenser/init.sh,target=devcontainer-decondenser/init.sh \
    ./scripts/init-workspace.sh && ./devcontainer-decondenser/init.sh

COPY --chown=$USER:$USER ./devcontainer-decondenser/.cargo/config.toml "$HOME/.cargo/config.toml"
