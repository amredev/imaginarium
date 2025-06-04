FROM amredev-devcontainer-base

ENV PATH="$HOME/.node/bin:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"

ENV CONTAINER_WORKSPACE=$HOME/dev/decondenser

RUN --mount=source=amrebash,target=amrebash \
    --mount=source=devcontainer-decondenser/setup.sh,target=devcontainer-decondenser/setup.sh \
    ./amrebash/setup-workspace.sh && ./devcontainer-decondenser/setup.sh

WORKDIR $CONTAINER_WORKSPACE
