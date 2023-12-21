ARG BASEDEV_VERSION=v0.20.11

FROM kbuley/basedevcontainer:${BASEDEV_VERSION}-alpine
ARG CREATED
ARG COMMIT
ARG VERSION=local
ARG USERNAME=vscode
LABEL \
  org.opencontainers.image.authors="kevin@buley.org" \
  org.opencontainers.image.created=$CREATED \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$COMMIT \
  org.opencontainers.image.url="https://github.com/kbuley/reactdevcontainer" \
  org.opencontainers.image.documentation="https://github.com/kbuley/reactdevcontainer" \
  org.opencontainers.image.source="https://github.com/kbuley/reactdevcontainer" \
  org.opencontainers.image.title="React Dev container Alpine" \
  org.opencontainers.image.description="React TS development container for Visual Studio Code Remote Containers development"

USER root
VOLUME [ "/workspace/node_modules" ]

# Install Alpine packages
# hadolint ignore=DL3018
RUN apk add -q --update --progress --no-cache nodejs npm yarn && \
  mkdir -p /workspace/node_modules && \
  chown -R ${USERNAME}:${USERNAME} /workspace

USER ${USERNAME}
# Setup shells
COPY shell/.zshrc-specific shell/.welcome.sh /home/${USERNAME}/
# Sets directories for NPM global packages
ENV NODE_PATH="/home/${USERNAME}/.npm-packages/lib/node_modules" \
  MANPATH="/home/${USERNAME}/.npm-packages/share/man"
RUN echo "prefix = /home/${USERNAME}/.npm-packages" >> /home/${USERNAME}/.npmrc && \
  chmod 600 /home/${USERNAME}/.npmrc
ENV PATH=/home/${USERNAME}/.npm-packages/bin:$PATH

