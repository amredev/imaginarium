FROM ghcr.io/amredev/devcontainer-base:latest

ARG INSTALL_SH=devcontainer-decondenser/install.sh
RUN --mount=source=amrebash,target=amrebash \
    --mount=source=$INSTALL_SH,target=$INSTALL_SH $INSTALL_SH

ENV PATH="$HOME/.node/bin:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"
