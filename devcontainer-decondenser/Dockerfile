FROM amredev-devcontainer-base

ENV PATH="$HOME/.node/bin:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"

ENV CONTAINER_WORKSPACE=$HOME/dev/decondenser
WORKDIR $CONTAINER_WORKSPACE

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=source=amrebash,target=amrebash \
    --mount=source=devcontainer-decondenser/setup.sh,target=devcontainer-decondenser/setup.sh \
    ./amrebash/setup-workspace.sh && ./devcontainer-decondenser/setup.sh

COPY --chown=$USER:$USER ./devcontainer-decondenser/.cargo/config.toml "$HOME/.cargo/config.toml"
