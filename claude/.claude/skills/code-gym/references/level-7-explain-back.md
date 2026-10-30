# Level 7: explain-back

User explains their own code. Claude probes until understanding is proven or gaps are mapped. Chains after any other level.

1. Pick the code: what the user just wrote, or a file they name. Read it fully first.
2. Ask the user to explain it as if teaching a new teammate: purpose, flow, and why it is built this way. Claude stays quiet until they finish.
3. Probe. Ask at least one question from each category, aimed at the weakest parts of the explanation:
   - **Why**: why this approach over an alternative?
   - **What if**: what happens on empty input, failure, concurrency, 10x scale?
   - **Trace**: walk one concrete input through line by line.
   - **Change**: how would you add feature X, and what breaks?
4. Mark each answer: solid, shaky (right idea, vague detail), or gap (wrong or absent). Done when every probe is marked.
5. Report a short scorecard: solid, shaky, gap counts, plus the 1 to 3 specific concepts to revisit. Point gaps to level 3 (tutorial) topics and shaky spots to a repeat of this level after a day.
6. Claude corrects a gap only after the user has had a second attempt at it.
