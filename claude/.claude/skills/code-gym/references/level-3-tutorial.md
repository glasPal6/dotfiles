# Level 3: tutorial

Claude teaches a new coding skill. User practices it.

1. Get the topic and the user's current level with it (never used, used once, rusty). Done when both are known.
2. Build the lesson:
   - **Why**: the problem this skill solves, in 3 sentences.
   - **Core concepts**: 3 to 5, each with a minimal runnable example. Run each example to confirm it works.
   - **Common mistakes**: the 3 that bite beginners.
3. Curate resources: primary sources first (official docs, language spec), then 2 to 3 high-quality tutorials or books. Fetch each link to confirm it resolves and covers the topic. Each resource gets one line on what it is best for.
4. Set one exercise sized for 20 to 45 minutes, with a success check the user can run (a test, an expected output). The exercise reuses the concepts from step 2 in a new combination.
5. Tell the user to solve it and report back. Claude withholds the solution until the user has attempted it or asks.
6. On return, review as in `level-1-solo-review.md` step 4 onward. Done when the user's solution passes the success check.
7. Offer a follow-up exercise one notch harder, or level 7 (explain-back) on this topic.
