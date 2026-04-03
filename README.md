# devcontainer

Base images for ClankerGuru development containers.

## Images

| Tag | What's inside |
|-----|--------------|
| `ghcr.io/clankerguru/devcontainer:gradle-9.4.1-jbr17` | Ubuntu 24.04, JetBrains Runtime 17, Gradle 9.4.1, git, gh, Starship |
| `ghcr.io/clankerguru/devcontainer:gradle-latest` | Same, always points to the latest JVM image |

## Use in a project

In your project's `.devcontainer/Dockerfile`:

```dockerfile
FROM ghcr.io/clankerguru/devcontainer:gradle-latest
```

That's it. No installs, no SDKMAN, no downloads. Everything is in the image.

## What's included (JVM)

Installed via SDKMAN:
- **JetBrains Runtime 17** (`17.0.14-jbr`)
- **Gradle 9.4.1**

System tools:
- git, gh (GitHub CLI), curl, unzip, openssh-client
- Starship prompt
- sudo (passwordless for `dev` user)

Not included (handled by devcontainer features):
- Docker-in-Docker (add `ghcr.io/devcontainers/features/docker-in-docker:2` in devcontainer.json)

## Build locally

```bash
docker build -t devcontainer:jvm-local jvm/
```

## Variants

Each subdirectory is a variant:

```
devcontainer/
├── jvm/           ← JetBrains Runtime + Gradle
├── swift/         ← (future)
└── node/          ← (future)
```

Tags follow the pattern: `<variant>-<details>` and `<variant>-latest`.

## Offline / private registry

```bash
docker pull ghcr.io/clankerguru/devcontainer:gradle-latest
docker tag ghcr.io/clankerguru/devcontainer:gradle-latest localhost:5000/devcontainer:gradle-latest
docker push localhost:5000/devcontainer:gradle-latest
```
