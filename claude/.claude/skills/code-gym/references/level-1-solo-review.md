# Level 1: solo-review

User plans and codes. Claude reviews.

1. Get the plan from the user. Done when it names inputs, outputs, and the steps between.
2. Challenge the plan: list unhandled edge cases and ambiguous steps as questions. Done when the user has answered or consciously deferred each one.
3. Tell the user to code it and report back. Claude writes no solution code and edits none of the user's files.
4. On return, read the user's code and review it. Check every item:
   - correctness against the plan
   - edge cases from step 2
   - naming and structure vs the surrounding code
   - error handling
   - tests (exist, cover the edge cases)
5. Report findings as bullets, most severe first, each with file:line. Each finding is a question or a pointer ("what happens when `items` is empty on line 42?") rather than a rewrite. Give the fix only when the user asks.
6. Done when every finding is fixed by the user or consciously dismissed. Re-review changed code.
