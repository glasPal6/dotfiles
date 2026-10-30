# Review

Shared by the `/gym-*` skills that review the user's code.

Read the user's code, then check every item:

- correctness against the plan
- edge cases raised during planning
- naming and structure vs the surrounding code
- error handling
- tests (exist, cover the edge cases)
- leftover `TODO(user)` stubs or `not implemented` bodies

Report findings as bullets, most severe first, each with file:line. Each finding is a question or a pointer ("what happens when `items` is empty on line 42?") rather than a rewrite. Give the fix only when the user asks.

Done when every finding is fixed by the user or consciously dismissed. Re-review changed code.
