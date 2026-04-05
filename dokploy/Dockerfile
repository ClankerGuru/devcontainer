FROM ghcr.io/clankerguru/devcontainer:gradle-latest

USER root

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

USER dev

# Extensions: Java / Kotlin / Gradle / Android
RUN code-server --install-extension vscjava.vscode-java-pack \
    && code-server --install-extension fwcd.kotlin \
    && code-server --install-extension vscjava.vscode-gradle \
    && code-server --install-extension naco-siren.gradle-language \
    && code-server --install-extension mathiasfrohlich.Kotlin \
    # Go
    && code-server --install-extension golang.go \
    # Rust
    && code-server --install-extension rust-lang.rust-analyzer \
    && code-server --install-extension tamasfe.even-better-toml \
    # General
    && code-server --install-extension sainnhe.everforest \
    && code-server --install-extension editorconfig.editorconfig \
    && code-server --install-extension eamodio.gitlens \
    && code-server --install-extension usernamehw.errorlens \
    && code-server --install-extension esbenp.prettier-vscode

# Default settings
RUN mkdir -p /home/dev/.local/share/code-server/User \
    && cat > /home/dev/.local/share/code-server/User/settings.json <<'EOF'
{
  "workbench.colorTheme": "Everforest Dark",
  "terminal.integrated.fontFamily": "JetBrains Mono, monospace",
  "editor.fontFamily": "JetBrains Mono, monospace",
  "editor.fontSize": 14,
  "editor.formatOnSave": true,
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "editor.minimap.enabled": false,

  "java.jdt.ls.java.home": "/home/dev/.sdkman/candidates/java/current",
  "java.configuration.runtimes": [
    {
      "name": "JavaSE-17",
      "path": "/home/dev/.sdkman/candidates/java/current",
      "default": true
    }
  ],
  "java.import.gradle.java.home": "/home/dev/.sdkman/candidates/java/current",
  "java.import.gradle.home": "/home/dev/.sdkman/candidates/gradle/current",

  "kotlin.languageServer.enabled": true,
  "kotlin.java.home": "/home/dev/.sdkman/candidates/java/current",

  "go.gopath": "/home/dev/go",
  "go.goroot": "/usr/local/go",
  "go.toolsManagement.autoUpdate": true,

  "rust-analyzer.check.command": "clippy",

  "[kotlin]": { "editor.defaultFormatter": "fwcd.kotlin" },
  "[java]": { "editor.defaultFormatter": "redhat.java" },
  "[go]": { "editor.defaultFormatter": "golang.go" },
  "[rust]": { "editor.defaultFormatter": "rust-lang.rust-analyzer" },
  "[toml]": { "editor.defaultFormatter": "tamasfe.even-better-toml" }
}
EOF

EXPOSE 8443

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["source $HOME/.sdkman/bin/sdkman-init.sh && source $HOME/.cargo/env && exec code-server --bind-addr 0.0.0.0:8443 --auth password /workspace"]
