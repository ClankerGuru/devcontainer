# devcontainer

[![Build](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml/badge.svg)](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Docker images for ClankerGuru development and infrastructure.

## Images

| Image | Tag | Purpose |
|-------|-----|---------|
| Dev | `gradle-latest` | Full-stack: JVM, Go, Rust, Android SDK, Neovim, Charm tools |
| Infra | `infra-latest` | Admin: coder, dokploy, hapi CLIs, Charm tools |
| code-server | `code-server-latest` | Dev image + code-server + extensions + Everforest theme |

All images get weekly dated snapshots (`*-YYYYMMDD`) for rollback.

## Dev image (`jvm/Dockerfile`)

| Tool | Version |
|------|---------|
| Ubuntu | 24.04 |
| JetBrains Runtime | 17.0.14 |
| Kotlin | 2.3.20 |
| Gradle | 9.4.1 |
| Go | 1.24.2 |
| Rust | stable |
| Android SDK | cmdline-tools, adb, build-tools 35.0.1, android-35 |
| Neovim | 0.11.7 + LazyVim |
| LazyGit, LazySql | latest |
| Bun | latest |
| gum, glow, vhs, skate | latest |
| Starship, gh, ripgrep, fd, fzf, GPG, SSH | system |

## Infra image (`infra/Dockerfile`)

| Tool | Version |
|------|---------|
| Ubuntu | 24.04 |
| zsh, tmux, Starship | system |
| coder CLI | 2.31.7 |
| dokploy CLI | latest |
| hapi (Hostinger) | latest |
| gum, glow, vhs, skate | pinned |
| LazyGit, LazySql | pinned |
| gh, git, ssh, gpg, ripgrep, fd, fzf | system |

## code-server image (`dokploy/Dockerfile`)

Dev image + code-server with pre-installed extensions:

- Java Extension Pack, Gradle for Java, Kotlin
- Go, rust-analyzer, Even Better TOML
- Everforest Dark theme, GitLens, Error Lens, Prettier

## Build locally

```bash
docker build -t devcontainer:dev jvm/
docker build -t devcontainer:infra infra/
docker build -t devcontainer:code-server dokploy/   # requires gradle-latest
```

## CI

Builds all three images on tag push (`gradle-*`) and weekly (Mondays 06:00 UTC).

- `dev` and `infra` build in parallel
- `code-server` builds after `dev` (depends on `gradle-latest`)
- Dated tags for rollback: `gradle-YYYYMMDD`, `infra-YYYYMMDD`, `code-server-YYYYMMDD`

## Structure

```text
devcontainer/
├── jvm/                <- Dev image
│   └── Dockerfile
├── infra/              <- Infra image
│   └── Dockerfile
├── dokploy/            <- code-server image
│   └── Dockerfile
├── .github/workflows/
│   └── build.yml
└── README.md
```

## Related

- **[terraform](https://github.com/ClankerGuru/terraform)** — Coder workspace templates and Dokploy compose files
- **[wrkx](https://github.com/ClankerGuru/wrkx)** — Multi-repo workspace management Gradle plugin

## Release

```bash
git tag gradle-vX.Y.Z
git push --tags
```

## License

[MIT](LICENSE)
