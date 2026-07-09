#!/usr/bin/env bash
# Wire the dotfiles AI kit into live config via symlinks. Idempotent — safe to re-run.
# Canonical source: ~/dotfiles/.claude/ (shared guidance/workflows plus client adapters)
set -euo pipefail

DOT="$HOME/dotfiles/.claude"
CODEX="$DOT/codex"

link() { # link <target> <linkpath> — backs up a real file/dir at linkpath first
  local target="$1" linkpath="$2"
  if [ -e "$linkpath" ] && [ ! -L "$linkpath" ]; then
    mv "$linkpath" "$linkpath.bak.$(date +%Y%m%d%H%M%S)"
    echo "backed up: $linkpath"
  fi
  mkdir -p "$(dirname "$linkpath")"
  ln -sfn "$target" "$linkpath"
  echo "linked: $linkpath -> $target"
}

# Claude Code — global memory, settings, skills, agents, rules
link "$DOT/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$DOT/settings.json" "$HOME/.claude/settings.json"
link "$DOT/skills"    "$HOME/.claude/skills"
link "$DOT/agents"    "$HOME/.claude/agents"
link "$DOT/rules"     "$HOME/.claude/rules"

# Shared instructions
link "$DOT/AGENTS.md" "$HOME/.codex/AGENTS.md"
link "$DOT/AGENTS.md" "$HOME/.gemini/GEMINI.md"

# Codex — stable config plus client-specific hooks, rules, and agents
link "$CODEX/config.toml" "$HOME/.codex/config.toml"
link "$CODEX/hooks.json" "$HOME/.codex/hooks.json"

for agent in "$CODEX/agents"/*.toml; do
  link "$agent" "$HOME/.codex/agents/$(basename "$agent")"
done

for rule in "$CODEX/rules"/*.rules; do
  link "$rule" "$HOME/.codex/rules/$(basename "$rule")"
done

# Codex discovers portable skills from ~/.agents/skills. Keep Claude-only UI
# workflows out of that surface while sharing everything else by symlink.
for skill in "$DOT/skills"/*; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  [ "$name" = "ui-design" ] && continue
  link "$skill" "$HOME/.agents/skills/$name"
done

if command -v claude >/dev/null && ! claude mcp get context7 >/dev/null 2>&1; then
  claude mcp add --scope user --transport http context7 https://mcp.context7.com/mcp >/dev/null ||
    echo "warning: could not configure Context7 for Claude Code"
fi

command -v agent-browser >/dev/null ||
  echo "note: browser automation missing — run: bun add -g agent-browser && bun pm -g trust agent-browser && agent-browser install"

echo "done."
