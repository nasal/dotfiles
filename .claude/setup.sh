#!/usr/bin/env bash
# Wire the dotfiles AI kit into live config via symlinks. Idempotent — safe to re-run.
# Canonical source: ~/dotfiles/.claude/ (AGENTS.md, skills/, agents/, rules/, templates/)
set -euo pipefail

DOT="$HOME/dotfiles/.claude"

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

# Claude Code — global memory, skills, agents, rules
link "$DOT/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$DOT/skills"    "$HOME/.claude/skills"
link "$DOT/agents"    "$HOME/.claude/agents"
link "$DOT/rules"     "$HOME/.claude/rules"

# Codex + Gemini read the same canonical file
link "$DOT/AGENTS.md" "$HOME/.codex/AGENTS.md"
link "$DOT/AGENTS.md" "$HOME/.gemini/GEMINI.md"

command -v agent-browser >/dev/null ||
  echo "note: browser automation missing — run: bun add -g agent-browser && bun pm -g trust agent-browser && agent-browser install"

echo "done."
