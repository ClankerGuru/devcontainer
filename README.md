# devcontainer

[![Build](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml/badge.svg)](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Container images and Coder templates for ClankerGuru development and infrastructure.

## Images

| Tag | Purpose | What's in it |
|-----|---------|-------------|
| `gradle-latest` | Development | JVM, Go, Rust, Android SDK, Bun, Neovim/LazyVim, Charm tools |
| `infra-latest` | Infrastructure admin | coder CLI, dokploy CLI, hapi CLI, Charm tools, LazyGit, LazySql |
| `code-server-latest` | Standalone browser IDE | Dev image + code-server + extensions + Everforest theme |

All images also get dated weekly snapshots (`*-YYYYMMDD`) for rollback.

## Dev image (`gradle-latest`)

| Tool | Version | Installed via |
|------|---------|---------------|
| Ubuntu | 24.04 | base image |
| JetBrains Runtime | 17.0.14 | SDKMAN |
| Kotlin | 2.3.20 | SDKMAN |
| Gradle | 9.4.1 | SDKMAN |
| Go | 1.24.2 | direct download |
| Rust | stable | rustup |
| Android SDK | cmdline-tools, platform-tools (adb), build-tools 35.0.1, android-35 | sdkmanager |
| Neovim | 0.11.7 | GitHub releases |
| LazyVim | latest | starter config |
| LazyGit | latest | go install |
| LazySql | latest | go install |
| Bun | latest | curl installer |
| gh (GitHub CLI) | latest | apt |
| Starship | latest | curl installer |
| gum, glow, vhs, skate | latest | go install |
| ripgrep, fd, fzf | system | apt |
| GPG / SSH | system | apt |
| gcc / g++ / make | system | apt |

## Infra image (`infra-latest`)

| Tool | Version | Installed via |
|------|---------|---------------|
| Ubuntu | 24.04 | base image |
| zsh, tmux | system | apt |
| coder CLI | 2.31.7 | curl installer |
| dokploy CLI | latest | npm |
| hapi (Hostinger) | latest | binary (if available) |
| gum, glow, vhs, skate | pinned | pre-built binaries |
| LazyGit | pinned | pre-built binary |
| LazySql | pinned | pre-built binary |
| gh (GitHub CLI) | latest | apt |
| Starship | latest | curl installer |
| ripgrep, fd, fzf | system | apt |
| GPG / SSH | system | apt |

## Code-server image (`code-server-latest`)

Dev image + code-server with pre-installed extensions:

- **Java**: Java Extension Pack, Gradle for Java, Gradle Language Support
- **Kotlin**: Kotlin language support, Kotlin formatter
- **Go**: Go extension
- **Rust**: rust-analyzer, Even Better TOML
- **General**: Everforest Dark theme, GitLens, Error Lens, Prettier, EditorConfig

## Coder templates

### Dev workspace (`coder-template/`)

Uses `gradle-latest`. Parameters:

| Parameter | Type | Default |
|-----------|------|---------|
| Repository | string | `git@github.com:ClankerGuru/wrkx.git` |
| Branch | string | `main` |
| Claude Code | bool | true |
| GitHub Copilot CLI | bool | true |
| Codex CLI | bool | true |
| OpenCode | bool | true |
| VS Code Desktop | bool | false |
| code-server (browser) | bool | false |

IDEs: IntelliJ IDEA Ultimate (default), GoLand, RustRover, WebStorm via JetBrains Gateway.

### Infra workspace (`infra-template/`)

Uses `infra-latest`. Lightweight workspace for infrastructure administration with code-server for browser access.

### Deploy templates to Coder

```bash
coder templates push gradle-workspace --directory ./coder-template
coder templates push infra-workspace --directory ./infra-template
```

## Dokploy code-server (`dokploy/`)

Standalone code-server deployment for Dokploy. Uses `code-server-latest`.

Deploy in Dokploy as a Compose project using `dokploy/docker-compose.yml`. Set `PASSWORD` and `TZ` in environment variables, add your domain with HTTPS enabled on port 8443.

## Build locally

```bash
# Dev image
docker build -t devcontainer:gradle-local jvm/

# Infra image
docker build -t devcontainer:infra-local infra/

# Code-server image (requires gradle-latest to exist)
docker build -t devcontainer:code-server-local dokploy/
```

## Repository structure

```text
devcontainer/
├── jvm/                    <- Dev image Dockerfile
│   └── Dockerfile
├── infra/                  <- Infra image Dockerfile
│   └── Dockerfile
├── dokploy/                <- Code-server image + Dokploy compose
│   ├── Dockerfile
│   └── docker-compose.yml
├── coder-template/         <- Dev workspace Coder template
│   └── main.tf
├── infra-template/         <- Infra workspace Coder template
│   └── main.tf
├── .github/workflows/
│   └── build.yml           <- Builds all images on tag push + weekly cron
└── README.md
```

## Version management

- Versions are pinned as Dockerfile `ARG`s for reproducibility
- CI rebuilds **weekly** (Mondays 06:00 UTC)
- Scheduled builds get dated tags for rollback
- To bump a pinned version, update the ARG and create a new release tag

## Release

```bash
git tag gradle-vX.Y.Z
git push --tags
```

Or create a release on GitHub -- the tag triggers all builds.

## License

[MIT](LICENSE)
