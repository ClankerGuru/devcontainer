# Coder Template — Gradle Workspace

A parameterized Coder template for creating Gradle development workspaces. One template, any repo, any agent.

## What it does

When you create a workspace from this template, it:

1. Asks which **repo** to clone
2. Asks which **branch** to checkout
3. Asks which **image** to use (base, Claude, Copilot, Codex, OpenCode, or all)
4. Creates a Docker container with persistent volumes for Gradle cache and workspace data
5. Clones the repo on first start
6. Starts the Coder agent for SSH, Gateway, and web terminal access

## Parameters

| Parameter | Default | Options |
|-----------|---------|---------|
| **repo** | `git@github.com:ClankerGuru/wrkx.git` | Any git URL |
| **branch** | `main` | Any branch/tag |
| **image** | `ghcr.io/clankerguru/devcontainer:gradle-all` | Select from dropdown: Base, Claude, Copilot, Codex, OpenCode, All |

## Volumes

Each workspace gets two persistent Docker volumes:

| Volume | Path | Purpose |
|--------|------|---------|
| `coder-<owner>-<workspace>-gradle` | `/home/dev/.gradle` | Gradle cache, wrapper, dependencies |
| `coder-<owner>-<workspace>-workspace` | `/workspace` | Cloned repo, source code |

Volumes survive workspace restarts. Deleting the workspace deletes the volumes.

## Install in Coder

### Via CLI

```bash
coder templates create gradle-workspace \
  --directory ./coder-template \
  --variable repo=git@github.com:ClankerGuru/wrkx.git
```

### Via UI

1. Open `https://coder.clanker.zone`
2. Go to **Templates → Create Template**
3. Upload the `coder-template/` directory
4. Name it `gradle-workspace`

## Create a workspace

### Via CLI

```bash
# wrkx with Claude
coder create wrkx-claude \
  --template gradle-workspace \
  --parameter repo=git@github.com:ClankerGuru/wrkx.git \
  --parameter image=ghcr.io/clankerguru/devcontainer:gradle-claude

# gort with all agents
coder create gort-all \
  --template gradle-workspace \
  --parameter repo=git@github.com:ClankerGuru/gort.git \
  --parameter image=ghcr.io/clankerguru/devcontainer:gradle-all

# openspec with Copilot
coder create openspec-copilot \
  --template gradle-workspace \
  --parameter repo=git@github.com:ClankerGuru/openspec-gradle.git \
  --parameter image=ghcr.io/clankerguru/devcontainer:gradle-copilot
```

### Via UI

1. Open `https://coder.clanker.zone`
2. Click **Create Workspace**
3. Select **gradle-workspace** template
4. Fill in repo URL, branch, and image
5. Click **Create**

## Connect

| Client | Command / Steps |
|--------|-----------------|
| **JetBrains Gateway** | Install Coder plugin → connect to `coder.clanker.zone` → select workspace |
| **VS Code** | Install Coder extension → connect → select workspace |
| **SSH** | `coder ssh wrkx-claude` |
| **Browser** | Open workspace in Coder UI → Terminal tab |

## Example: full workflow

```bash
# Install Coder CLI
curl -fsSL https://coder.com/install.sh | sh

# Login to your Coder instance
coder login https://coder.clanker.zone

# Create a workspace for the wrkx plugin with Claude Code
coder create wrkx --template gradle-workspace \
  --parameter repo=git@github.com:ClankerGuru/wrkx.git \
  --parameter image=ghcr.io/clankerguru/devcontainer:gradle-claude

# SSH into it
coder ssh wrkx

# Inside the workspace:
cd /workspace
./gradlew build
claude "explain the plugin structure"
```
