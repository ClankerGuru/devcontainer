# ClankerGuru Rust Development Workspace

Thin, zsh-based development container for Rust projects. Built on Ubuntu 24.04 with code-server, Neovim (LazyVim), and a curated set of CLI tools.

## What's in the image

### Language & Toolchain

| Tool | Version | Notes |
|------|---------|-------|
| Rust | stable (via rustup) | Includes clippy, rustfmt, rust-analyzer |
| cargo-watch | latest | Auto-rebuild on file changes |
| cargo-edit | latest | `cargo add` / `cargo rm` commands |

### Editors

| Tool | Notes |
|------|-------|
| code-server | Browser-based VS Code with Everforest Dark theme |
| Neovim | 0.11.7 with LazyVim starter config |

### code-server Extensions

| Extension | Purpose |
|-----------|---------|
| `rust-lang.rust-analyzer` | Rust language support |
| `tamasfe.even-better-toml` | TOML file support |
| `sainnhe.everforest` | Everforest Dark color theme |

### CLI Tools

| Tool | Version | Purpose |
|------|---------|---------|
| zsh | system | Default shell |
| tmux | system | Terminal multiplexer |
| git | system | Version control |
| gh | latest | GitHub CLI |
| ripgrep | system | Fast search |
| fd-find | system | Fast file finder |
| fzf | system | Fuzzy finder |
| jq | system | JSON processor |
| yq | latest | YAML processor |
| htop | system | Process viewer |
| tree | system | Directory listing |
| starship | latest | Cross-shell prompt |
| bun | latest | JS runtime (for AI agents) |
| gum | 0.16.0 | Charm — interactive scripts |
| glow | 2.1.0 | Charm — markdown renderer |
| vhs | 0.9.0 | Charm — terminal recorder |
| skate | 1.0.1 | Charm — key-value store |
| lazygit | 0.51.1 | Terminal UI for git |
| lazysql | 0.3.9 | Terminal UI for SQL |

### Fonts

| Font | Purpose |
|------|---------|
| JetBrains Mono Nerd Font | Editor / terminal font |
| OpenDyslexic Nerd Font | Accessibility alternative |

## How to build locally

```bash
docker build -t clankerguru/workspace:rust-latest ./rust
```

## How to run

```bash
docker run -it --rm \
  -p 8080:8080 \
  -v "$(pwd)":/workspace \
  clankerguru/workspace:rust-latest
```

Start code-server inside the container:

```bash
code-server --bind-addr 0.0.0.0:8080 /workspace
```

## Image size estimate

~1.8 GB (uncompressed). The bulk comes from the Rust toolchain, compiled cargo tools (cargo-watch, cargo-edit), code-server, Neovim, and Nerd Fonts. The build-essential/libssl-dev packages are retained for native crate compilation.

## User

- Username: `dev`
- Shell: `/bin/zsh`
- Passwordless sudo: yes
- WORKDIR: `/workspace`
- CARGO_HOME: `/home/dev/.cargo`
- RUSTUP_HOME: `/home/dev/.rustup`
