FROM ubuntu:24.04

ARG SDKMAN_JDK=17.0.14-jbr
ARG SDKMAN_GRADLE=9.4.1
ARG GO_VERSION=1.24.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip zip openssh-client ca-certificates bash sudo \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
       -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && curl -sS https://starship.rs/install.sh | sh -s -- --yes \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" | tar -C /usr/local -xz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN groupadd -r dev && useradd -r -g dev -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

USER dev
SHELL ["/bin/bash", "-c"]

ENV SDKMAN_DIR=/home/dev/.sdkman \
    GOPATH=/home/dev/go

RUN export sdkman_auto_answer=true \
    && export sdkman_selfupdate_feature=false \
    && curl -s "https://get.sdkman.io?rcupdate=false" -o /tmp/sdkman-install.sh \
    && sed -i '/find.*folder.*-type f -delete/d' /tmp/sdkman-install.sh \
    && bash /tmp/sdkman-install.sh \
    && rm /tmp/sdkman-install.sh \
    && source "$SDKMAN_DIR/bin/sdkman-init.sh" \
    && sdk install java ${SDKMAN_JDK} \
    && sdk install gradle ${SDKMAN_GRADLE} \
    && rm -rf "$SDKMAN_DIR/archives/"* "$SDKMAN_DIR/tmp/"* \
    && curl -fsSL https://bun.sh/install | bash \
    && ln -sf /home/dev/.bun/bin/bun /home/dev/.bun/bin/node \
    && go install github.com/charmbracelet/gum@latest \
    && go install github.com/charmbracelet/glow@latest \
    && go install github.com/charmbracelet/vhs@latest \
    && go install github.com/charmbracelet/skate@latest \
    && echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
    && mkdir -p ~/.gradle/wrapper ~/.gradle/caches

ENV JAVA_HOME=/home/dev/.sdkman/candidates/java/current \
    GRADLE_HOME=/home/dev/.sdkman/candidates/gradle/current \
    GRADLE_USER_HOME=/home/dev/.gradle \
    BUN_INSTALL=/home/dev/.bun \
    PATH="/home/dev/go/bin:/home/dev/.bun/bin:/home/dev/.sdkman/candidates/java/current/bin:/home/dev/.sdkman/candidates/gradle/current/bin:/usr/local/go/bin:${PATH}"

WORKDIR /workspace
