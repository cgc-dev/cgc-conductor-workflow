# Agents — Conceptual Overview

The conceptual agents that power the Conductor workflow, and how each tool implements them.

| # | Agent | Purpose |
|---|---|---|
| 1 | **Conductor** | Orchestrates the full pipeline for EPIC-level features |
| 2 | **Planning Subagent** | Codebase research → detailed implementation plan |
| 3 | **Implement Subagent** | TDD execution per task: RED → GREEN → REFACTOR |
| 4 | **Code Review Subagent** | Correctness, edge cases, quality, error handling |
| 5 | **Security Subagent** | OWASP Top 10 review |
| 6 | **Test Subagent** | Write + run tests, validate coverage |
| 7 | **Documentation Subagent** | README + CHANGELOG updates |

## Tool Mappings

| Agent | Claude Code | GitHub Copilot | Cursor |
|---|---|---|---|
| Conductor | `agents/claude/agents/conductor.md` | `agents/copilot/agents/Conductor.agent.md` | `agents/cursor/rules/conductor.mdc` |
| Planning | `agents/claude/agents/planning-subagent.md` | `agents/copilot/agents/planning-subagent.agent.md` | `agents/cursor/rules/planning.mdc` |
| Implement | `agents/claude/agents/implement-subagent.md` | `agents/copilot/agents/implement-subagent.agent.md` | `agents/cursor/rules/implement.mdc` |
| Code Review | `agents/claude/agents/code-review-subagent.md` | `agents/copilot/agents/code-review-subagent.agent.md` | `agents/cursor/rules/code-review.mdc` |
| Security | `agents/claude/agents/security-subagent.md` | `agents/copilot/agents/security-subagent.agent.md` | `agents/cursor/rules/security-review.mdc` |
| Test | `agents/claude/agents/test-subagent.md` | `agents/copilot/agents/test-subagent.agent.md` | `agents/cursor/rules/test.mdc` |
| Docs | `agents/claude/agents/documentation-subagent.md` | `agents/copilot/agents/documentation-subagent.agent.md` | `agents/cursor/rules/docs.mdc` |

## Tool-Specific Features

| Tool | Beyond Agents | Location |
|---|---|---|
| Claude Code | 12 slash commands | `agents/claude/commands/` |
| GitHub Copilot | 4 prompt templates | `agents/copilot/prompts/` |
| Cursor | Agent mode instructions | `agents/cursor/instructions/` |
