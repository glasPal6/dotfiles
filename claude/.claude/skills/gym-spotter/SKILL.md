---
name: gym-spotter
description: You code, Claude steps in only with graduated hints when you're stuck.
disable-model-invocation: true
argument-hint: "What are you building?"
---

Read `~/.claude/skills/code-gym/RULES.md` and follow it throughout.

User drives. Claude gives only hints, per the ladder in `~/.claude/skills/code-gym/HINTS.md`.

1. Get the goal and what the user already tried.
2. Start at rung 1 of the ladder and climb as it describes.
3. Done when the user's code works. Review per `~/.claude/skills/code-gym/REVIEW.md`.
4. Close with a tally of rungs used per problem, and which concept the user kept needing (candidate topic for `/gym-lesson`).
