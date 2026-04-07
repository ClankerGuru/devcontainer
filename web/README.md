# ClankerGuru Web Development Workspace

Thin, zsh-based development container for web projects using Bun and Node.js. Built on Ubuntu 24.04 with code-server, Neovim (LazyVim), and a curated set of CLI tools.

## What's in the image

### Language & Toolchain

| Tool | Version | Notes |
|------|---------|-------|
| Bun | latest | Primary JS/TS runtime |
| Node.js | LTS (via NodeSource) | Compatibility runtime |

### Editors

| Tool | Notes |
|------|-------|
| code-server | Browser-based VS Code with Everforest Dark theme |
| Neovim | 0.11.7 with LazyVim starter config |

### code-server Extensions

| Extension | Purpose |
|-----------|---------|
| `dbaeumer.vscode-eslint` | ESLint integration |
| `esbenp.prettier-vscode` | Prettier code formatter |
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
docker build -t clankerguru/workspace:web-latest ./web
```

## How to run

```bash
docker run -it --rm \
  -p 8080:8080 \
  -p 3000:3000 \
  -p 5173:5173 \
  -v "$(pwd)":/workspace \
  clankerguru/workspace:web-latest
```

Start code-server inside the container:

```bash
code-server --bind-addr 0.0.0.0:8080 /workspace
```

Ports 3000 and 5173 are mapped for common dev server defaults (Next.js, Vite, etc.).

## Image size estimate

~1.0 GB (uncompressed). The lightest of the three images since there is no compiled toolchain. The bulk comes from Node.js, code-server, Neovim, and Nerd Fonts.

## User

- Username: `dev`
- Shell: `/bin/zsh`
- Passwordless sudo: yes
- WORKDIR: `/workspace`
