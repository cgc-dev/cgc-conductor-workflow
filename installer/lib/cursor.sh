# install_cursor(repo_dir, target_dir)
# Installs Cursor rules and instructions from agents/cursor/ into target.
install_cursor() {
  local repo="$1"
  local target="$2"
  local src_rules="$repo/agents/cursor/rules"
  local src_instructions="$repo/agents/cursor/instructions"

  echo "  → Installing Cursor rules..."
  if [[ -d "$src_rules" ]]; then
    mkdir -p "$target/.cursor/rules"
    cp -r "$src_rules/." "$target/.cursor/rules/"
    echo "    ✓ $(find "$src_rules" -maxdepth 1 -name '*.mdc' | wc -l) rules → .cursor/rules/"
  fi

  if [[ -d "$src_instructions" ]]; then
    mkdir -p "$target/.cursor/instructions"
    cp -r "$src_instructions/." "$target/.cursor/instructions/"
    echo "    ✓ $(find "$src_instructions" -maxdepth 1 -name '*.md' | wc -l) instruction files → .cursor/instructions/"
  fi
}
