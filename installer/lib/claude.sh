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
    local dst_settings="$target/.claude/settings.json"
    if [[ ! -f "$dst_settings" ]]; then
      cp "$src_settings" "$dst_settings"
      echo "    ✓ settings.json → .claude/settings.json"
    else
      # Merge customModes — add conductor mode if not already present
      if command -v python3 &>/dev/null; then
        python3 - "$src_settings" "$dst_settings" <<'PYEOF'
import json, sys
src = json.load(open(sys.argv[1]))
dst_path = sys.argv[2]
dst = json.load(open(dst_path))
src_modes = src.get("customModes", [])
dst_modes = dst.setdefault("customModes", [])
existing_ids = {m.get("id") for m in dst_modes}
added = 0
for mode in src_modes:
    if mode.get("id") not in existing_ids:
        dst_modes.append(mode)
        added += 1
open(dst_path, "w").write(json.dumps(dst, indent=2) + "\n")
print(f"    ✓ settings.json merged ({added} new mode(s) added)" if added else "    ~ settings.json (conductor mode already present)")
PYEOF
      else
        echo "    ~ .claude/settings.json (already exists — python3 not found, skipped merge)"
        echo "      To add Conductor mode manually, copy customModes from $src_settings"
      fi
    fi
  fi
}
