# Changelog

All notable changes to this project will be documented in this file.

This format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## How to maintain this file

- **One entry per release.** Group changes under the release version and date.
- **Keep an `[Unreleased]` section** at the top for changes not yet in a release. Move it to a version heading when you cut a release.
- **Use these change types** (omit types with no entries):
  - `Added` — new features
  - `Changed` — changes to existing functionality
  - `Deprecated` — features that will be removed in a future release
  - `Removed` — features removed in this release
  - `Fixed` — bug fixes
  - `Security` — vulnerability fixes
- **Write for humans.** One line per change; link to PRs or issues where useful.
- **AI agents** (documentation-subagent, update-docs command) will append entries here automatically when code changes are committed.

---

## [Unreleased]

### Fixed
- `/conductor` slash command now carries the full conductor workflow (anti-drift rules, mandatory stops, style guides, security triggers, session state, evidence checklists) — previously was an 18-line stub that omitted all enforcement rules
- `settings.json` Conductor custom mode instructions now include the full workflow summary instead of 3-sentence placeholder
- Installer (`install.sh` / `install.ps1`) now merges `customModes` into an existing `.claude/settings.json` instead of silently skipping the file — projects with a pre-existing settings.json now get the Conductor custom mode

### Added
- `conductor.md` added to repo's own `.claude/commands/` so `/conductor` works when developing in this repo itself
- Zero-clone bootstrap installer: `bootstrap.sh` and `bootstrap.ps1` — install into any project with a single curl command, no git clone required
- Self-contained bootstrap: all agent/installer files embedded as base64 — single HTTP request, no secondary downloads
- `/conductor` slash command for Claude Code CLI
- `.claude/settings.json` for VS Code extension Conductor mode support
- `CLAUDE.md` and `AGENTS.md` auto-installed to target projects
- Bootstrap auto-cleanup: script self-deletes after successful install
- YAML frontmatter on all Claude slash commands for UI picker support
- `build.sh` — regenerates `bootstrap.sh` whenever agent/installer files change

### Changed
- Install command uses download-then-run (compatible with Git Bash on Windows)

### Initial
- Initial project setup from CGC Copilot template

### Removed
- Deleted `.github/workflows/` (deploy.yml and deploy-azure.yml) — contained hardcoded project-specific values from another project
