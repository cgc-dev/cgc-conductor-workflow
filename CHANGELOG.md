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

### Added
- Initial project setup from CGC Copilot template

### Removed
- Deleted `.github/workflows/` (deploy.yml and deploy-azure.yml) — contained hardcoded project-specific values from another project
