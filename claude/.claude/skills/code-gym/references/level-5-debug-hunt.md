# Level 5: debug-hunt

Claude plants a bug. User finds and fixes it.

1. Ask language, difficulty (obvious, subtle, nasty), and source: a fresh small program Claude writes, or the user's existing code (needs explicit consent plus a git branch or copy so the original stays intact).
2. Write or pick a program of 30 to 100 lines with a test suite that passes. Plant exactly one bug. Prefer realistic bug classes: off-by-one, wrong operator, mutated shared state, missed null case, wrong async ordering, stale cache. Run the suite: done when the bug produces a visible symptom (failing test or wrong output).
3. Record the bug location and cause in a scratch file outside the user's repo. Show the user only the symptom.
4. Tell the user to hunt: reproduce, locate, fix. Claude answers questions with hints from `level-6-hint-ladder.md`, never with the location.
5. On return, run the suite. Done when it is green and the user can name the root cause.
6. Grade: found it vs needed hints (count them), fix quality (root cause vs symptom patch), and method (reproduced first, bisected, read the stack trace, or guessed). Reveal the planted bug and compare.
7. Offer the next bug one difficulty step up.
