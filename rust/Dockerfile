# ============================================================================
# ClankerGuru Rust Development Workspace
# Tag: rust-latest
# Base: ubuntu:24.04
# Shell: zsh
# ============================================================================

FROM ubuntu:24.04

ARG TARGETARCH

# --------------------------------------------------------------------------
# System packages
# --------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh tmux git curl unzip zip openssh-client ca-certificates bash sudo \
    gpg gpg-agent gnupg2 ripgrep fd-find fzf jq make wget htop tree \
    fontconfig xz-utils \
    build-essential pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------------
# yq
# --------------------------------------------------------------------------
RUN curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_$(dpkg --print-architecture)" \
    -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq

# --------------------------------------------------------------------------
# gh CLI
# --------------------------------------------------------------------------
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------------
# Starship prompt
# --------------------------------------------------------------------------
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# --------------------------------------------------------------------------
# Neovim 0.11.7
# --------------------------------------------------------------------------
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then NVIM_ARCH="x86_64"; else NVIM_ARCH="arm64"; fi \
    && curl -fsSL "https://github.com/neovim/neovim/releases/download/v0.11.7/nvim-linux-${NVIM_ARCH}.tar.gz" \
       | tar -C /usr/local --strip-components=1 -xz

# --------------------------------------------------------------------------
# Charm tools — helper function: install_from_tar
# --------------------------------------------------------------------------
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then GOARCH="x86_64"; else GOARCH="arm64"; fi \
    && install_from_tar() { \
      local url="$1" name="$2" tmpdir; \
      tmpdir="$(mktemp -d)"; \
      curl -fsSL "$url" | tar xz -C "$tmpdir"; \
      found="$(find "$tmpdir" -type f -name "$name" | head -1)"; \
      mv "$found" /usr/local/bin/"$name"; \
      chmod +x /usr/local/bin/"$name"; \
      rm -rf "$tmpdir"; \
      test -x /usr/local/bin/"$name"; \
    } \
    && install_from_tar "https://github.com/charmbracelet/gum/releases/download/v0.16.0/gum_0.16.0_Linux_${GOARCH}.tar.gz" gum \
    && install_from_tar "https://github.com/charmbracelet/glow/releases/download/v2.1.0/glow_2.1.0_Linux_${GOARCH}.tar.gz" glow \
    && install_from_tar "https://github.com/charmbracelet/vhs/releases/download/v0.9.0/vhs_0.9.0_Linux_${GOARCH}.tar.gz" vhs \
    && install_from_tar "https://github.com/charmbracelet/skate/releases/download/v1.0.1/skate_1.0.1_Linux_${GOARCH}.tar.gz" skate \
    && install_from_tar "https://github.com/jesseduffield/lazygit/releases/download/v0.51.1/lazygit_0.51.1_Linux_${GOARCH}.tar.gz" lazygit \
    && install_from_tar "https://github.com/jorgerojas26/lazysql/releases/download/v0.3.9/lazysql_Linux_${GOARCH}.tar.gz" lazysql

# --------------------------------------------------------------------------
# Fonts — JetBrains Mono + OpenDyslexic (Nerd Font)
# --------------------------------------------------------------------------
RUN mkdir -p /usr/share/fonts/nerd-fonts \
    && curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" | tar xJ -C /usr/share/fonts/nerd-fonts \
    && curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/OpenDyslexic.tar.xz" | tar xJ -C /usr/share/fonts/nerd-fonts \
    && fc-cache -fv

# --------------------------------------------------------------------------
# code-server (installed as root)
# --------------------------------------------------------------------------
RUN curl -fsSL https://code-server.dev/install.sh | sh

# --------------------------------------------------------------------------
# User: dev (passwordless sudo, zsh)
# --------------------------------------------------------------------------
RUN useradd -m -s /bin/zsh dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev

# --------------------------------------------------------------------------
# Rust via rustup (stable)
# --------------------------------------------------------------------------
ENV RUSTUP_HOME=/home/dev/.rustup
ENV CARGO_HOME=/home/dev/.cargo
ENV PATH="${CARGO_HOME}/bin:${PATH}"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable \
    && . "$CARGO_HOME/env" \
    && rustup component add clippy rustfmt rust-analyzer

# --------------------------------------------------------------------------
# Cargo tools
# --------------------------------------------------------------------------
RUN . "$CARGO_HOME/env" \
    && cargo install cargo-watch \
    && cargo install cargo-edit

# --------------------------------------------------------------------------
# Bun (for AI agent installation)
# --------------------------------------------------------------------------
RUN curl -fsSL https://bun.sh/install | bash

# --------------------------------------------------------------------------
# LazyVim config
# --------------------------------------------------------------------------
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim \
    && rm -rf ~/.config/nvim/.git

# --------------------------------------------------------------------------
# code-server extensions
# --------------------------------------------------------------------------
RUN code-server --install-extension rust-lang.rust-analyzer \
    && code-server --install-extension tamasfe.even-better-toml \
    && code-server --install-extension sainnhe.everforest

# --------------------------------------------------------------------------
# code-server settings
# --------------------------------------------------------------------------
RUN mkdir -p /home/dev/.local/share/code-server/User
COPY --chown=dev:dev <<'SETTINGS' /home/dev/.local/share/code-server/User/settings.json
{
  "workbench.colorTheme": "Everforest Dark",
  "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font Mono",
  "editor.fontFamily": "JetBrainsMono Nerd Font Mono",
  "editor.fontSize": 14,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": false,
  "rust-analyzer.check.command": "clippy",
  "[rust]": { "editor.defaultFormatter": "rust-lang.rust-analyzer" },
  "[toml]": { "editor.defaultFormatter": "tamasfe.even-better-toml" }
}
SETTINGS

# --------------------------------------------------------------------------
# Shell config
# --------------------------------------------------------------------------
RUN cat >> ~/.zshrc <<'ZSH'
# Starship prompt
eval "$(starship init zsh)"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rust / Cargo
. "$HOME/.cargo/env"
ZSH

ENV BUN_INSTALL=/home/dev/.bun \
    PATH="/home/dev/.bun/bin:${PATH}"

WORKDIR /workspace

CMD ["zsh"]
