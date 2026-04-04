terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}
provider "coder" {}

data "coder_provisioner" "me" {}
data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

data "coder_parameter" "repo" {
  name         = "repo"
  display_name = "Repository"
  description  = "Git repository URL to clone"
  type         = "string"
  default      = "git@github.com:ClankerGuru/wrkx.git"
}

data "coder_parameter" "branch" {
  name         = "branch"
  display_name = "Branch"
  description  = "Branch to checkout after cloning"
  type         = "string"
  default      = "main"
}

data "coder_parameter" "image" {
  name         = "image"
  display_name = "Image"
  description  = "Devcontainer image to use"
  type         = "string"
  default      = "ghcr.io/clankerguru/devcontainer:gradle-all"
  option {
    name  = "Base (no agents)"
    value = "ghcr.io/clankerguru/devcontainer:gradle-latest"
  }
  option {
    name  = "Claude Code"
    value = "ghcr.io/clankerguru/devcontainer:gradle-claude"
  }
  option {
    name  = "Copilot CLI"
    value = "ghcr.io/clankerguru/devcontainer:gradle-copilot"
  }
  option {
    name  = "Codex CLI"
    value = "ghcr.io/clankerguru/devcontainer:gradle-codex"
  }
  option {
    name  = "OpenCode"
    value = "ghcr.io/clankerguru/devcontainer:gradle-opencode"
  }
  option {
    name  = "All agents"
    value = "ghcr.io/clankerguru/devcontainer:gradle-all"
  }
}

resource "coder_agent" "main" {
  os             = "linux"
  arch           = data.coder_provisioner.me.arch
  dir            = "/workspace"
  startup_script = <<-EOT
    # Clone the repo if not already present
    if [ ! -d "/workspace/.git" ]; then
      git clone --branch "${data.coder_parameter.branch.value}" "${data.coder_parameter.repo.value}" /workspace
    fi

    # Source SDKMAN for the agent session
    if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
      . "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
  EOT
}

module "jetbrains_gateway" {
  count          = data.coder_workspace.me.start_count
  source         = "registry.coder.com/modules/jetbrains-gateway/coder"
  version        = "1.1.0"
  agent_id       = coder_agent.main.id
  folder         = "/workspace"
  jetbrains_ides = ["IU"]
  default        = "IU"
  latest         = true
}

module "code_server" {
  count    = data.coder_workspace.me.start_count
  source   = "registry.coder.com/coder/code-server/coder"
  version  = "1.4.4"
  agent_id = coder_agent.main.id
}

resource "docker_image" "workspace" {
  name = data.coder_parameter.image.value
}

resource "docker_volume" "gradle_cache" {
  name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-gradle"
}

resource "docker_volume" "workspace_data" {
  name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-workspace"
}

resource "docker_container" "workspace" {
  count   = data.coder_workspace.me.start_count
  name    = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
  image   = docker_image.workspace.image_id
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]

  hostname = data.coder_workspace.me.name
  dns      = ["1.1.1.1"]

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "GRADLE_OPTS=-Xmx2g -XX:+UseG1GC",
  ]

  volumes {
    volume_name    = docker_volume.gradle_cache.name
    container_path = "/home/dev/.gradle"
  }

  volumes {
    volume_name    = docker_volume.workspace_data.name
    container_path = "/workspace"
  }

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
}
