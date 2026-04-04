# devcontainer

[![Build](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml/badge.svg)](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Base development container images for ClankerGuru projects.

## Images

### Base (no agents)

| Tag | Description |
|-----|-------------|
| `ghcr.io/clankerguru/devcontainer:gradle-9.4.1-jbr17` | Pinned versions |
| `ghcr.io/clankerguru/devcontainer:gradle-latest` | Always latest base |

### With AI agents

| Tag | Agents included |
|-----|----------------|
| `ghcr.io/clankerguru/devcontainer:gradle-claude` | Claude Code |
| `ghcr.io/clankerguru/devcontainer:gradle-copilot` | GitHub Copilot CLI |
| `ghcr.io/clankerguru/devcontainer:gradle-codex` | OpenAI Codex CLI |
| `ghcr.io/clankerguru/devcontainer:gradle-opencode` | OpenCode |
| `ghcr.io/clankerguru/devcontainer:gradle-all` | All four agents |

## Use in a project

Create `.devcontainer/Dockerfile`:

```dockerfile
FROM ghcr.io/clankerguru/devcontainer:gradle-all
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

Open in JetBrains Gateway, IntelliJ IDEA, VS Code, or GitHub Codespaces.

## What's inside

### Base image (`gradle-latest`)

| Tool | Version | Installed via |
|------|---------|---------------|
| Ubuntu | 24.04 | base image |
| JetBrains Runtime | 17.0.14 | SDKMAN |
| Kotlin | 2.3.20 | SDKMAN |
| Gradle | 9.4.1 | SDKMAN |
| Go | 1.24.2 | direct download |
| Bun | latest | curl installer |
| git | system | apt |
| gh (GitHub CLI) | latest | apt |
| Starship | latest | curl installer |
| gum | latest | go install |
| glow | latest | go install |
| vhs | latest | go install |
| skate | latest | go install |

User: `dev` with passwordless sudo.

### Agent images

Built on top of the base. All agents installed via Bun:

| Agent | Package | Runtime |
|-------|---------|---------|
| Claude Code | `@anthropic-ai/claude-code` | Bun |
| Copilot CLI | `@github/copilot` | Bun |
| Codex CLI | `@openai/codex` | Bun |
| OpenCode | `opencode-ai` | Bun |

### Not in the image

Docker-in-Docker is added at container startup via the devcontainer feature `ghcr.io/devcontainers/features/docker-in-docker:2`. This is handled by `devcontainer.json`, not the Dockerfile.

## Build locally

```bash
# Base image
docker build -t devcontainer:gradle-local jvm/

# Agent variant (claude, copilot, codex, opencode, or all)
docker build -t devcontainer:gradle-claude --build-arg AGENTS=claude jvm-agents/
docker build -t devcontainer:gradle-all --build-arg AGENTS=all jvm-agents/
```

## Repository structure

```
devcontainer/
├── jvm/                    ← Base image Dockerfile
│   └── Dockerfile
├── jvm-agents/             ← Agent variant Dockerfile (builds FROM base)
│   └── Dockerfile
├── coder-template/         ← Coder workspace template (Terraform)
│   ├── main.tf
│   └── README.md
├── .github/workflows/
│   └── build.yml           ← Builds base + 5 agent variants on push
└── README.md
```

## Connect

| Client | How |
|--------|-----|
| **JetBrains Gateway** | Dev Containers → select project folder |
| **IntelliJ IDEA** | Open folder → "Reopen in Dev Container" |
| **VS Code** | Open folder → "Reopen in Container" |
| **GitHub Codespaces** | Code → Codespaces → New |
| **Coder** | Create workspace from template → connect via Gateway/VS Code/browser |

## Offline / private registry

```bash
docker pull ghcr.io/clankerguru/devcontainer:gradle-all
docker tag ghcr.io/clankerguru/devcontainer:gradle-all localhost:5000/devcontainer:gradle-all
docker push localhost:5000/devcontainer:gradle-all
```

## License

[MIT](LICENSE)
