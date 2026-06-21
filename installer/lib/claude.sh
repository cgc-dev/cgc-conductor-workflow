# install_claude(repo_dir, target_dir)
# Installs Claude Code agents, commands, and settings into target.
install_claude() {
  local repo="$1"
  local target="$2"
  local src_agents="$repo/agents/claude/agents"
  local src_commands="$repo/agents/claude/commands"
  local src_settings="$repo/agents/claude/settings.json"

  echo "  → Installing Claude Code agents..."
  if [[ -d "$src_agents" ]]; then
    mkdir -p "$target/.claude/agents"
    cp -r "$src_agents/." "$target/.claude/agents/"
    echo "    ✓ $(find "$src_agents" -maxdepth 1 -name '*.md' | wc -l) agents → .claude/agents/"
  else
    echo "    ⚠ No agents at $src_agents"
  fi

  if [[ -d "$src_commands" ]]; then
    mkdir -p "$target/.claude/commands"
    cp -r "$src_commands/." "$target/.claude/commands/"
    echo "    ✓ $(find "$src_commands" -maxdepth 1 -name '*.md' | wc -l) commands → .claude/commands/"
  fi

  if [[ -f "$src_settings" ]]; then
    mkdir -p "$target/.claude"
    if [[ ! -f "$target/.claude/settings.json" ]]; then
      cp "$src_settings" "$target/.claude/settings.json"
      echo "    ✓ settings.json → .claude/settings.json"
    else
      echo "    ~ .claude/settings.json (already exists — skipped)"
    fi
  fi
}
