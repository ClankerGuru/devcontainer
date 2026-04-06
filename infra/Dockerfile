FROM ubuntu:24.04

ARG CODER_VERSION=2.31.7
ARG GUM_VERSION=0.16.0
ARG GLOW_VERSION=2.1.0
ARG VHS_VERSION=0.9.0
ARG SKATE_VERSION=1.0.1
ARG LAZYGIT_VERSION=0.51.1
ARG LAZYSQL_VERSION=0.3.9

RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh tmux git curl unzip zip openssh-client ca-certificates bash sudo \
    gpg gpg-agent gnupg2 \
    ripgrep fd-find fzf jq \
    nodejs npm \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
       -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && curl -sS https://starship.rs/install.sh | sh -s -- --yes \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

# Helper: download a tarball and install the named binary to /usr/local/bin.
# Works regardless of whether the tarball contains a subdirectory or flat files.
# Charm tools + LazyGit + LazySql (pre-built binaries)
RUN set -e \
    && ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then GOARCH="x86_64"; else GOARCH="arm64"; fi \
    && install_from_tar() { \
         local url="$1" bin="$2" tmpdir; \
         tmpdir=$(mktemp -d); \
         curl -fsSL "$url" | tar xz -C "$tmpdir"; \
         find "$tmpdir" -name "$bin" -type f -exec mv {} /usr/local/bin/ \; ; \
         if [ ! -f "/usr/local/bin/$bin" ]; then \
           echo "ERROR: $bin not found in $url" >&2; exit 1; \
         fi; \
         chmod +x "/usr/local/bin/$bin"; \
         rm -rf "$tmpdir"; \
       } \
    # gum
    && install_from_tar "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_Linux_${GOARCH}.tar.gz" gum \
    # glow
    && install_from_tar "https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_Linux_${GOARCH}.tar.gz" glow \
    # vhs
    && install_from_tar "https://github.com/charmbracelet/vhs/releases/download/v${VHS_VERSION}/vhs_${VHS_VERSION}_Linux_${GOARCH}.tar.gz" vhs \
    # skate
    && install_from_tar "https://github.com/charmbracelet/skate/releases/download/v${SKATE_VERSION}/skate_${SKATE_VERSION}_Linux_${GOARCH}.tar.gz" skate \
    # lazygit
    && install_from_tar "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${GOARCH}.tar.gz" lazygit \
    # lazysql
    && install_from_tar "https://github.com/jorgerojas26/lazysql/releases/download/v${LAZYSQL_VERSION}/lazysql_Linux_${GOARCH}.tar.gz" lazysql

# Coder CLI
RUN curl -fsSL "https://coder.com/install.sh" | sh -s -- --version ${CODER_VERSION}

# Dokploy CLI
RUN npm install -g @dokploy/cli

# Hostinger CLI (hapi) - build from source needs Go, install if binary available
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://github.com/hostinger/api-cli/releases/latest/download/hapi-linux-${ARCH}.tar.gz" \
       | tar xz -C /usr/local/bin \
    || echo "hapi binary not available, install manually with go install"

RUN groupadd -r dev && useradd -r -g dev -m -s /bin/zsh dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

USER dev

# Shell config
RUN echo 'eval "$(starship init zsh)"' >> ~/.zshrc

WORKDIR /workspace
