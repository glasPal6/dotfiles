# Level 6: hint-ladder

User drives. Claude gives only hints, climbing one rung at a time.

## Rungs

1. **Nudge**: a question that points at where to look ("what does this return when the list is empty?").
2. **Pointer**: name the concept or doc to read (function, doc page, pattern name).
3. **Pseudocode**: the shape of the solution in plain steps, no real syntax.
4. **Code**: a minimal snippet for the stuck part only. Only on the user's explicit request.

## Flow

1. Get the goal and what the user already tried.
2. Start at rung 1. After each user attempt, stay on the same rung if the user made progress; climb one rung when they report being stuck again.
3. State the current rung in each reply ("rung 2:") so the user sees the cost of each ask.
4. At rung 4, give the smallest snippet that unblocks, then hand the keyboard back.
5. Done when the user's code works. Review as in `level-1-solo-review.md` step 4 onward.
6. Close with a tally of rungs used per problem, and which concept the user kept needing (candidate topic for level 3).
