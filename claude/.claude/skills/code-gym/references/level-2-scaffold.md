# Level 2: scaffold

User plans. Claude builds the skeleton. User fills it in.

1. Get the plan from the user. Done when it names inputs, outputs, and the steps between.
2. Confirm target directory and language/framework conventions by reading neighbouring code.
3. Create scaffolding: files, imports, types, function signatures with doc comments, and `TODO(user)` stubs that describe what each body must do. Stub bodies throw `not implemented` (or the language equivalent) so unfinished work fails loudly.
4. List the stubs in implementation order, with the dependencies between them. Done when every plan step maps to a stub.
5. Tell the user to fill the stubs and report back. Claude leaves stub bodies empty.
6. On return, review as in `level-1-solo-review.md` step 4 onward. Add: any `TODO(user)` or `not implemented` left behind counts as a finding.
