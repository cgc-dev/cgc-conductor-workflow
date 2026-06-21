# install_copilot(repo_dir, target_dir)
# Installs GitHub Copilot agents and prompts from agents/copilot/ into target.
install_copilot() {
  local repo="$1"
  local target="$2"
  local src_agents="$repo/agents/copilot/agents"
  local src_prompts="$repo/agents/copilot/prompts"

  echo "  → Installing GitHub Copilot agents..."
  if [[ -d "$src_agents" ]]; then
    mkdir -p "$target/.github/agents"
    cp -r "$src_agents/." "$target/.github/agents/"
    echo "    ✓ $(find "$src_agents" -maxdepth 1 -name '*.agent.md' | wc -l) agents → .github/agents/"
  fi

  if [[ -d "$src_prompts" ]]; then
    mkdir -p "$target/.github/prompts"
    cp -r "$src_prompts/." "$target/.github/prompts/"
    echo "    ✓ $(find "$src_prompts" -maxdepth 1 -name '*.md' | wc -l) prompts → .github/prompts/"
  fi
}
