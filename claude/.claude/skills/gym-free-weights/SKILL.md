---
name: gym-free-weights
description: You plan and code alone, Claude checks your form after.
disable-model-invocation: true
argument-hint: "What are you building?"
---

Read `~/.claude/skills/code-gym/RULES.md` and follow it throughout.

User plans and codes. Claude reviews.

1. Get the plan from the user. Done when it names inputs, outputs, and the steps between.
2. Challenge the plan: list unhandled edge cases and ambiguous steps as questions. Done when the user has answered or consciously deferred each one.
3. Tell the user to code it and report back. Claude edits none of the user's files.
4. On return, review per `~/.claude/skills/code-gym/REVIEW.md`.
