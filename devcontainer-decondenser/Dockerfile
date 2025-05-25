FROM amredev-devcontainer-base

ENV PATH="$HOME/.node/bin:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"
ENV CARGO_HOME="$HOME/.cargo"
ENV RUSTUP_HOME="$HOME/.rustup"

ENV CONTAINER_WORKSPACE=$HOME/dev/decondenser
WORKDIR $CONTAINER_WORKSPACE

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=source=scripts/utils,target=scripts/utils \
    --mount=source=scripts/init-workspace.sh,target=scripts/init-workspace.sh \
    --mount=source=install/tools,target=install/tools \
    --mount=source=devcontainer-decondenser/init.sh,target=devcontainer-decondenser/init.sh \
    ./scripts/init-workspace.sh && ./devcontainer-decondenser/init.sh

COPY --chown=$USER:$USER ./devcontainer-decondenser/.cargo/config.toml "$HOME/.cargo/config.toml"
