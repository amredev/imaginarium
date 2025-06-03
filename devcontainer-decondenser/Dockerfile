FROM amredev-devcontainer-base

ENV CONTAINER_WORKSPACE=$HOME/dev/decondenser
RUN --mount=source=amrebash,target=amrebash \
    ./amrebash/setup-workspace.sh \
    && ./amrebash/install/node.sh 20.19.2 \
    && ./amrebash/install/rust.sh 1.87.0 --target wasm32-unknown-unknown \
    && ./amrebash/install/taplo.sh 0.10.0 \
    && ./amrebash/install/typos.sh 1.32.0

ENV PATH="$HOME/.node/bin:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"

WORKDIR $CONTAINER_WORKSPACE
