---
name: gym-red-green
description: Claude writes failing tests, you turn them green.
disable-model-invocation: true
argument-hint: "What are you building?"
---

Read `~/.claude/skills/code-gym/RULES.md` and follow it throughout.

User plans. Claude writes failing tests. User makes them pass.

1. Get the plan from the user. Done when it names inputs, outputs, and the steps between.
2. Confirm target directory, test framework, and test conventions by reading neighbouring tests.
3. Write tests that pin the plan's behaviour through the public interface: happy path, edge cases, error cases. One behaviour per test, named for that behaviour. Create only stub signatures needed for the tests to compile.
4. Run the tests. Done when they fail red for the right reason (missing behaviour, not syntax or import errors).
5. Show the user the red output. Tell them to make the tests pass in small steps and report back. Claude leaves implementation bodies empty and the tests unchanged.
6. On return, run the tests, then review per `~/.claude/skills/code-gym/REVIEW.md`. A behaviour the tests missed is a gap in Claude's tests: say so and add a test.
7. Done when tests are green and the review is clean.
