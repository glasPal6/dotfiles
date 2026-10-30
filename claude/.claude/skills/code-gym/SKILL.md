---
name: code-gym
description: Find the right gym level for your situation. A router over the gym skills.
disable-model-invocation: true
---

# Code Gym

You write the code, Claude coaches. Each level is its own skill: pick by how much help you want.

Before stating what a level does, read that level's SKILL.md: the summaries here are for orientation only.

## Build something

You have a real feature to code. Pick by how much structure you want from Claude.

- **`/gym-free-weights`**: you plan and code alone, Claude reviews your form after. Least help, most reps.
- **`/gym-training-wheels`**: you plan, Claude builds the frame (files, signatures, stubs), you fill it in.
- **`/gym-red-green`**: you plan, Claude writes the failing tests, you turn them green.
- **`/gym-spotter`**: you code, Claude steps in only with graduated hints when you are stuck. Never code unless you ask.

## Learn something new

- **`/gym-lesson`**: Claude teaches a skill you don't have yet: short lesson, runnable examples, curated resources, one exercise.

## Sharpen skills

- **`/gym-bug-hunt`**: Claude hides one bug in a small program (or a copy of your code). You find and fix it.
- **`/gym-teach-back`**: you explain your own code, Claude pokes holes. Run it after any other level to prove you understood what you built.

## Which one?

- New to the area: `/gym-lesson`, then `/gym-red-green`.
- Know the area, want reps: `/gym-free-weights`.
- Stuck on a design: `/gym-training-wheels`.
- Stuck mid-code: `/gym-spotter`.
- Code works but you can't say why: `/gym-teach-back`.
