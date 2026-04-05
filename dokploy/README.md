# Dokploy code-server

Standalone code-server deployment using the full devcontainer image with all tools.

## Deploy on Dokploy

1. Create a new **Compose** project in Dokploy
2. Paste the contents of `docker-compose.yml`
3. Set environment variables:
   - `PASSWORD` — login password (required)
   - `TZ` — timezone (e.g. `America/Los_Angeles`)
4. Add your domain in the **Domains** tab (port `8443`, HTTPS enabled)
5. Deploy

## What's included

Everything from the base devcontainer image:

- Java (JBR 17), Kotlin, Gradle
- Go + Charm tools (gum, glow, vhs, skate)
- Rust (stable)
- Android SDK (cmdline-tools, adb, build-tools, platform)
- Neovim + LazyVim, LazyGit, LazySql
- Bun, gh CLI, Starship, ripgrep, fd, fzf, GPG, SSH

Plus:
- code-server (pre-installed in image)
- Everforest Dark theme
- JetBrains Mono font

## Persistence

- code-server data (extensions, settings) — persisted via named volume
- `/workspace` — persisted via named volume

Both survive container restarts and redeployments.
