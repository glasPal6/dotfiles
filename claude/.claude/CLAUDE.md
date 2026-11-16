# Keep the codebase small

Aim to shrink the codebase, not grow it.
- Before writing new code, look for existing package, library, or in-repo utility that already does it. Prefer that over hand-rolled code.
- Fix root cause of current errors. No hacky workarounds, shims, suppressions, or special-case patches.
- Delete dead or redundant code when touching an area.
- Smallest diff that solves problem properly.

# Context hygiene: delegate to subagents

Keep the main context clean. Prefer subagents (Agent tool) for work whose output is large but whose conclusion is small.

## Delegate
- Codebase searches or questions spanning more than ~3 files: `researcher` (or `Explore`).
- Reading large files, logs, or diffs just to extract a fact.
- Running tests, builds, or linters: `test-runner`.
- Web or docs research.
- Independent tasks: launch their agents in one message so they run in parallel.

## Keep in the main thread
- Edits, design decisions, and anything needing back-and-forth with me.
- Small lookups (one known file, one grep).

## Briefing agents
- Give the agent full context: it has none of this conversation.
- Say what to return: a summary under ~200 words with `file:line` references, not raw dumps.

