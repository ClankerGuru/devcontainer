FROM ubuntu:24.04

ARG SDKMAN_JDK=17.0.14-jbr
ARG SDKMAN_GRADLE=9.4.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip zip openssh-client ca-certificates bash sudo \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
       -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && curl -sS https://starship.rs/install.sh | sh -s -- --yes \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN groupadd -r dev && useradd -r -g dev -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

USER dev
SHELL ["/bin/bash", "-c"]

ENV SDKMAN_DIR=/home/dev/.sdkman

RUN export sdkman_auto_answer=true \
    && export sdkman_selfupdate_feature=false \
    && curl -s "https://get.sdkman.io?rcupdate=false" -o /tmp/sdkman-install.sh \
    && sed -i 's/find "$sdkman_src_folder"/find "$sdkman_src_folder" 2>\/dev\/null/' /tmp/sdkman-install.sh \
    && bash /tmp/sdkman-install.sh \
    && rm /tmp/sdkman-install.sh \
    && source "$SDKMAN_DIR/bin/sdkman-init.sh" \
    && sdk install java ${SDKMAN_JDK} \
    && sdk install gradle ${SDKMAN_GRADLE} \
    && rm -rf "$SDKMAN_DIR/archives/"* "$SDKMAN_DIR/tmp/"* \
    && echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
    && mkdir -p ~/.gradle/wrapper ~/.gradle/caches

ENV JAVA_HOME=/home/dev/.sdkman/candidates/java/current \
    GRADLE_HOME=/home/dev/.sdkman/candidates/gradle/current \
    GRADLE_USER_HOME=/home/dev/.gradle \
    PATH="/home/dev/.sdkman/candidates/java/current/bin:/home/dev/.sdkman/candidates/gradle/current/bin:${PATH}"

WORKDIR /workspace
