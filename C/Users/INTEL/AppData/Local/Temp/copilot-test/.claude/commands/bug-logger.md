# Bug Logger

Capture bugs, defects, and unexpected behavior reports into `docs/bugs/` at any point during a conversation — without interrupting the current workflow.

## Trigger Conditions

Invoke this skill when the user:

**Explicitly mentions:**
- "bug", "broken", "defect", "issue", "not working", "crash", "error", "regression", "fail", "failing"

**Implicitly signals unexpected behavior**, such as:
- "why does X return null?"
- "this keeps failing"
- "something's off with Y"
- "that shouldn't happen"
- Any message implying a known-wrong or unexpected state

Triggers apply **mid-conversation at any point** — during planning, implementation, review, or idle phases.

## Behavior

1. **Scan for duplicates**: Check `docs/bugs/` for an existing file with a matching title or similar description. If found, update it instead of creating a new file.

2. **Create or update the bug file** following the format below.

3. **Notify the user briefly** — one line, e.g.:
   > Logged bug: `docs/bugs/2026-04-30-null-return-on-login.md`

4. **Continue** with whatever the current task was. Do NOT interrupt or derail the workflow.

## File Naming

```
docs/bugs/YYYY-MM-DD-<slug>.md
```

- `YYYY-MM-DD` = date the bug was reported
- `<slug>` = 2-5 word kebab-case summary (e.g. `null-return-on-login`, `conductor-skips-review-phase`)

## Bug File Format

```markdown
## Bug: {Short Title}

**Date Reported:** {YYYY-MM-DD}
**Reported By:** {Agent name that caught it}
**Status:** Open
**Severity:** {Critical / High / Medium / Low}

### Description
{What the user described, in their own words or a brief paraphrase}

### Steps to Reproduce
{If mentioned by the user, otherwise "Not provided"}

### Affected Files / Components
{If identifiable from context, otherwise "Unknown"}

### Suggested Fix Direction
{Agent's best inference based on code context, or "Unknown" if no context}

### Related Plan / EPIC
{Link to relevant plan or epic file if currently in scope, otherwise "N/A"}
```

## Severity Guide

| Severity | When to use |
|----------|-------------|
| Critical | Crash, data loss, security vulnerability |
| High     | Feature completely broken, no workaround |
| Medium   | Partial failure, workaround exists |
| Low      | Cosmetic, minor inconvenience |

Infer severity from context. Default to **Medium** when unclear.
