# ClankerGuru Go Development Workspace

Thin, zsh-based development container for Go projects. Built on Ubuntu 24.04 with code-server, Neovim (LazyVim), and a curated set of CLI tools.

## What's in the image

### Language & Toolchain

| Tool | Version | Notes |
|------|---------|-------|
| Go | 1.24.2 | `/usr/local/go` |
| golangci-lint | latest | Linter aggregator |

### Editors

| Tool | Notes |
|------|-------|
| code-server | Browser-based VS Code with Everforest Dark theme |
| Neovim | 0.11.7 with LazyVim starter config |

### code-server Extensions

| Extension | Purpose |
|-----------|---------|
| `golang.go` | Go language support |
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
docker build -t clankerguru/workspace:go-latest ./go
```

## How to run

```bash
docker run -it --rm \
  -p 8080:8080 \
  -v "$(pwd)":/workspace \
  clankerguru/workspace:go-latest
```

Start code-server inside the container:

```bash
code-server --bind-addr 0.0.0.0:8080 /workspace
```

## Image size estimate

~1.2 GB (uncompressed). The bulk comes from Go SDK, Neovim, code-server, and Nerd Fonts.

## User

- Username: `dev`
- Shell: `/bin/zsh`
- Passwordless sudo: yes
- WORKDIR: `/workspace`
