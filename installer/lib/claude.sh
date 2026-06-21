# install_claude(repo_dir, target_dir)
# Installs Claude Code agents and commands from agents/claude/ into target.
install_claude() {
  local repo="$1"
  local target="$2"
  local src_agents="$repo/agents/claude/agents"
  local src_commands="$repo/agents/claude/commands"

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
}
