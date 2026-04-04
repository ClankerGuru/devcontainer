ARG BASE_TAG=gradle-latest
FROM ghcr.io/clankerguru/devcontainer:${BASE_TAG}

ARG AGENTS="all"

RUN if [ "$AGENTS" = "all" ] || echo "$AGENTS" | grep -q "claude"; then \
        bun install -g @anthropic-ai/claude-code; \
    fi \
    && if [ "$AGENTS" = "all" ] || echo "$AGENTS" | grep -q "copilot"; then \
        bun install -g @github/copilot; \
    fi \
    && if [ "$AGENTS" = "all" ] || echo "$AGENTS" | grep -q "codex"; then \
        bun install -g @openai/codex; \
    fi \
    && if [ "$AGENTS" = "all" ] || echo "$AGENTS" | grep -q "opencode"; then \
        go install github.com/opencode-ai/opencode@latest; \
    fi
