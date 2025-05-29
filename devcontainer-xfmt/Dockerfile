FROM amredev-devcontainer-base

ENV CONTAINER_WORKSPACE=$HOME/xfmt
RUN --mount=source=amrebash,target=amrebash \
    ./amrebash/setup-workspace.sh \
    && ./amrebash/install/rust.sh 1.87.0 \
    && ./amrebash/install/taplo.sh 0.10.0 \
    && ./amrebash/install/typos.sh 1.32.0

ENV PATH="$HOME/.cargo/bin:$PATH"

WORKDIR $CONTAINER_WORKSPACE
