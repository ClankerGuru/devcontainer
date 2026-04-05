# devcontainer

[![Build](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml/badge.svg)](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Full-stack development container for ClankerGuru projects. One image with JVM, Go, Rust, Android SDK, and all the tooling. AI coding agents are installed at runtime via Coder workspace parameters.

## Image

| Tag | Description |
|-----|-------------|
| `ghcr.io/clankerguru/devcontainer:gradle-latest` | Always latest build |
| `ghcr.io/clankerguru/devcontainer:gradle-YYYYMMDD` | Dated weekly snapshot (for rollback) |
| `ghcr.io/clankerguru/devcontainer:gradle-v*` | Release-tagged builds |

## What's inside

| Tool | Version | Installed via |
|------|---------|---------------|
| Ubuntu | 24.04 | base image |
| JetBrains Runtime | 17.0.14 | SDKMAN |
| Kotlin | 2.3.20 | SDKMAN |
| Gradle | 9.4.1 | SDKMAN |
| Go | 1.24.2 | direct download |
| Rust | stable | rustup |
| Android SDK | cmdline-tools, platform-tools (adb), build-tools 35.0.1, android-35 | sdkmanager |
| Neovim | 0.11.2 | GitHub releases |
| LazyVim | latest | starter config |
| LazyGit | latest | go install |
| LazySql | latest | go install |
| Bun | latest | curl installer |
| gh (GitHub CLI) | latest | apt |
| Starship | latest | curl installer |
| gum | latest | go install |
| glow | latest | go install |
| vhs | latest | go install |
| skate | latest | go install |
| ripgrep, fd, fzf | system | apt |
| GPG / SSH | system | apt |
| gcc / g++ / make | system | apt |

User: `dev` with passwordless sudo.

### Not in the image

Docker-in-Docker is added at container startup via the devcontainer feature `ghcr.io/devcontainers/features/docker-in-docker:2`. This is handled by `devcontainer.json`, not the Dockerfile.

## Coder template

The `coder-template/` directory contains a Terraform template for [Coder](https://coder.com) workspaces.

### Workspace parameters

When creating a workspace, you can configure:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Repository | string | `git@github.com:ClankerGuru/wrkx.git` | Git repo to clone |
| Branch | string | `main` | Branch to checkout |
| Claude Code | bool | `true` | Install Claude Code CLI |
| GitHub Copilot CLI | bool | `true` | Install `gh copilot` extension |
| Codex CLI | bool | `true` | Install OpenAI Codex CLI |
| OpenCode | bool | `true` | Install OpenCode CLI |

### IDE access

The template configures the following IDE modules, available from the Coder dashboard:

| IDE | Module |
|-----|--------|
| IntelliJ IDEA Ultimate | JetBrains Gateway |
| GoLand | JetBrains Gateway |
| RustRover | JetBrains Gateway |
| WebStorm | JetBrains Gateway |
| VS Code Desktop | coder/vscode-desktop |
| code-server (browser) | coder/code-server |

### Deploy to Coder

```bash
coder templates push gradle-workspace --directory ./coder-template
```

## Use as a devcontainer

Create `.devcontainer/Dockerfile`:

```dockerfile
FROM ghcr.io/clankerguru/devcontainer:gradle-latest
```

Create `.devcontainer/devcontainer.json`:

```json
{
  "name": "my-project",
  "build": { "dockerfile": "Dockerfile" },
  "runArgs": ["--name", "my-project-dev", "--hostname", "my-project"],
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "remoteUser": "dev",
  "mounts": [
    "source=my-project-gradle-cache,target=/home/dev/.gradle,type=volume"
  ],
  "containerEnv": {
    "GRADLE_OPTS": "-Xmx2g -XX:+UseG1GC"
  }
}
```

## Build locally

```bash
docker build -t devcontainer:gradle-local jvm/
```

## Repository structure

```
devcontainer/
├── jvm/                    <- Dockerfile (single image, everything included)
│   └── Dockerfile
├── coder-template/         <- Coder workspace template (Terraform)
│   ├── main.tf
│   └── README.md
├── .github/workflows/
│   └── build.yml           <- Builds on tag push + weekly cron (Mon 06:00 UTC)
└── README.md
```

## Connect

| Client | How |
|--------|-----|
| **JetBrains Gateway** | Dev Containers > select project folder |
| **IntelliJ IDEA** | Open folder > "Reopen in Dev Container" |
| **VS Code** | Open folder > "Reopen in Container" |
| **GitHub Codespaces** | Code > Codespaces > New |
| **Coder** | Create workspace from template > connect via Gateway/VS Code/browser |

## Version management

- Versions are pinned as Dockerfile `ARG`s for reproducibility
- CI rebuilds **weekly** (Mondays 06:00 UTC) -- Go tools, Rust stable, Charm tools, LazyGit, and LazySql resolve to latest at build time
- Scheduled builds get a dated tag (`gradle-YYYYMMDD`) alongside `gradle-latest` for rollback
- To bump a pinned version (JDK, Kotlin, Gradle, Android SDK, Neovim), update the ARG in the Dockerfile and create a new release tag

## Release a new image

```bash
git tag gradle-vX.Y.Z
git push --tags
```

Or create a release on GitHub -- the tag triggers the build.

## Offline / private registry

```bash
docker pull ghcr.io/clankerguru/devcontainer:gradle-latest
docker tag ghcr.io/clankerguru/devcontainer:gradle-latest localhost:5000/devcontainer:gradle-latest
docker push localhost:5000/devcontainer:gradle-latest
```

## License

[MIT](LICENSE)
