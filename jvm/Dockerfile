FROM ubuntu:24.04

ARG SDKMAN_JDK=17.0.14-jbr
ARG SDKMAN_GRADLE=9.4.1
ARG SDKMAN_KOTLIN=2.3.20
ARG GO_VERSION=1.24.2
ARG RUST_VERSION=stable
ARG NEOVIM_VERSION=0.11.2
ARG ANDROID_BUILD_TOOLS=35.0.1
ARG ANDROID_PLATFORM=android-35

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip zip openssh-client ca-certificates bash sudo \
    gpg gpg-agent gnupg2 \
    ripgrep fd-find fzf make gcc g++ \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
       -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && curl -sS https://starship.rs/install.sh | sh -s -- --yes \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# Neovim (latest stable from GitHub releases)
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then NVIM_ARCH="x86_64"; else NVIM_ARCH="aarch64"; fi \
    && curl -fsSL "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" \
       | tar -C /usr/local --strip-components=1 -xz

# Go
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz" | tar -C /usr/local -xz

# Android SDK command-line tools + platform-tools (adb)
ENV ANDROID_HOME=/opt/android-sdk
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -fsSL "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" \
       -o /tmp/cmdline-tools.zip \
    && unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm /tmp/cmdline-tools.zip \
    && yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1 \
    && ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
       "platform-tools" \
       "build-tools;${ANDROID_BUILD_TOOLS}" \
       "platforms;${ANDROID_PLATFORM}" \
    && chmod -R a+r ${ANDROID_HOME}

ENV PATH="/usr/local/go/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

RUN groupadd -r dev && useradd -r -g dev -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev \
    && chown -R dev:dev ${ANDROID_HOME}

USER dev
SHELL ["/bin/bash", "-c"]

ENV SDKMAN_DIR=/home/dev/.sdkman \
    GOPATH=/home/dev/go \
    CARGO_HOME=/home/dev/.cargo \
    RUSTUP_HOME=/home/dev/.rustup

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${RUST_VERSION} \
    && . "$CARGO_HOME/env"

# SDKMAN (Java, Gradle, Kotlin) + Bun + Go tools
RUN export sdkman_auto_answer=true \
    && export sdkman_selfupdate_feature=false \
    && curl -s "https://get.sdkman.io?rcupdate=false" -o /tmp/sdkman-install.sh \
    && sed -i '/find.*folder.*-type f -delete/d' /tmp/sdkman-install.sh \
    && bash /tmp/sdkman-install.sh \
    && rm /tmp/sdkman-install.sh \
    && source "$SDKMAN_DIR/bin/sdkman-init.sh" \
    && sdk install java ${SDKMAN_JDK} \
    && sdk install gradle ${SDKMAN_GRADLE} \
    && sdk install kotlin ${SDKMAN_KOTLIN} \
    && rm -rf "$SDKMAN_DIR/archives/"* "$SDKMAN_DIR/tmp/"* \
    && curl -fsSL https://bun.sh/install | bash \
    && ln -sf /home/dev/.bun/bin/bun /home/dev/.bun/bin/node \
    && go install github.com/charmbracelet/gum@latest \
    && go install github.com/charmbracelet/glow@latest \
    && go install github.com/charmbracelet/vhs@latest \
    && go install github.com/charmbracelet/skate@latest \
    && go install github.com/jesseduffield/lazygit@latest \
    && go install github.com/jorgerojas26/lazysql@latest \
    && mkdir -p ~/.gradle/wrapper ~/.gradle/caches

# LazyVim
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim \
    && rm -rf ~/.config/nvim/.git

# Shell config
RUN echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc \
    && echo 'source "$HOME/.cargo/env"' >> ~/.bashrc \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc

ENV JAVA_HOME=/home/dev/.sdkman/candidates/java/current \
    GRADLE_HOME=/home/dev/.sdkman/candidates/gradle/current \
    KOTLIN_HOME=/home/dev/.sdkman/candidates/kotlin/current \
    GRADLE_USER_HOME=/home/dev/.gradle \
    BUN_INSTALL=/home/dev/.bun \
    PATH="/home/dev/.cargo/bin:/home/dev/go/bin:/home/dev/.bun/bin:/home/dev/.sdkman/candidates/kotlin/current/bin:/home/dev/.sdkman/candidates/java/current/bin:/home/dev/.sdkman/candidates/gradle/current/bin:${PATH}"

WORKDIR /workspace
