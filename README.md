# devcontainer

[![Build](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml/badge.svg)](https://github.com/ClankerGuru/devcontainer/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Docker images for ClankerGuru development and infrastructure.

## Images

| Image | Tag | Purpose |
|-------|-----|---------|
| JVM | `gradle-latest` | Full-stack: JVM, Go, Rust, Android SDK, Neovim, Charm tools |
| Infra | `infra-latest` | Admin: coder, dokploy, hapi CLIs, Charm tools |
| code-server | `code-server-latest` | JVM image + code-server + extensions + Everforest theme |
| Go | `go-latest` | Go workspace: Go 1.24.2, golangci-lint, code-server, Charm tools |
| Rust | `rust-latest` | Rust workspace: stable toolchain, clippy, rustfmt, cargo tools, code-server |
| Web | `web-latest` | Web workspace: Bun, Node.js LTS, code-server, Charm tools |

All images get weekly dated snapshots (`*-YYYYMMDD`) for rollback.

## JVM image (`jvm/Dockerfile`)

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

JVM image + code-server with pre-installed extensions:

- Java Extension Pack, Gradle for Java, Kotlin
- Go, rust-analyzer, Even Better TOML
- Everforest Dark theme, GitLens, Error Lens, Prettier

## Go image (`go/Dockerfile`)

See [go/README.md](go/README.md) for details.

| Tool | Version |
|------|---------|
| Ubuntu | 24.04 |
| Go | 1.24.2 |
| golangci-lint | latest |
| code-server | latest |
| Neovim | 0.11.7 + LazyVim |
| Bun | latest |
| gum, glow, vhs, skate | pinned |
| LazyGit, LazySql | pinned |

## Rust image (`rust/Dockerfile`)

See [rust/README.md](rust/README.md) for details.

| Tool | Version |
|------|---------|
| Ubuntu | 24.04 |
| Rust | stable (clippy, rustfmt, rust-analyzer) |
| cargo-watch, cargo-edit | latest |
| code-server | latest |
| Neovim | 0.11.7 + LazyVim |
| Bun | latest |
| gum, glow, vhs, skate | pinned |
| LazyGit, LazySql | pinned |

## Web image (`web/Dockerfile`)

See [web/README.md](web/README.md) for details.

| Tool | Version |
|------|---------|
| Ubuntu | 24.04 |
| Bun | latest |
| Node.js | LTS |
| code-server | latest |
| Neovim | 0.11.7 + LazyVim |
| gum, glow, vhs, skate | pinned |
| LazyGit, LazySql | pinned |

## Build locally

```bash
docker build -t ghcr.io/clankerguru/devcontainer:gradle-latest jvm/
docker build -t devcontainer:infra infra/
docker build -t devcontainer:code-server dokploy/   # requires ghcr.io/clankerguru/devcontainer:gradle-latest
docker build -t devcontainer:go go/
docker build -t devcontainer:rust rust/
docker build -t devcontainer:web web/
```

## CI

Builds all six images on tag push (`gradle-*`) and weekly (Mondays 06:00 UTC).

- `dev`, `infra`, `go`, `rust`, and `web` build in parallel
- `code-server` builds after `dev` (depends on `gradle-latest`)
- Dated tags for rollback: `gradle-YYYYMMDD`, `infra-YYYYMMDD`, `code-server-YYYYMMDD`, `go-YYYYMMDD`, `rust-YYYYMMDD`, `web-YYYYMMDD`

## Structure

```text
devcontainer/
├── jvm/                <- JVM dev image
│   └── Dockerfile
├── infra/              <- Infra image
│   └── Dockerfile
├── dokploy/            <- code-server image
│   └── Dockerfile
├── go/                 <- Go dev image
│   ├── Dockerfile
│   └── README.md
├── rust/               <- Rust dev image
│   ├── Dockerfile
│   └── README.md
├── web/                <- Web dev image
│   ├── Dockerfile
│   └── README.md
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
