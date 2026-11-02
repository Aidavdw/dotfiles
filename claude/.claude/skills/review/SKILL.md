---
name: my-review
description: "Review the code an approve verdict: explain it, flag what needs attention, then have subagents hunt bugs (with reproducers), unclear comments and architectural problems."
argument-hint: "[scope: a crate, directory or file, or all the changes since a certain commit] (default: the whole PR)"
disable-model-invocation: true
---

Review the PR in the checkout and decide whether the user should approve it. The **verdict** is the product: every finding either changes it or explains it. Report what would change the verdict or what a future reader of the code would get wrong; that bar leaves out style, cosmetics, micro-performance and the user's personal conventions (helpers after callers, `PlSmallStr` via `.into()`, the doc-comment wording of the `comments` skill), which apply only to the user's own code.

## Guardrails

- The checkout belongs to the user. Leave `HEAD`, the branch and the index exactly as they are: no `add`, `commit`, `reset`, `switch` or `stash`. The only files you write are reproducers (step 5), diagrams (step 4, outside the repo), and fixes when the user asks for them, always unstaged.

## Steps

1. **Find the diff and the scope.** Compare the branch this branch originates from.
   - **The scope** is the argument: a crate (`pc-engine` means `compute-plane/crates/pc-engine`), a directory or a file, or otherwise all the files that were changed in the diff. Match it against the diff's file list; ask when it is ambiguous. No argument means the whole changeset. Review every change of the set in scope, staged or not.

   Done when you have the diff, the list of files in scope.

2. **Explain the changes in the code.** Read the scoped diff in full, and the code around it that it calls or implements. Write what the PR does and why: the problem it solves, the mechanism, then the changes file by file. Give the whole PR a sentence or two and the scope the detail. Use the code's own terms.

3. **List what deserves attention.** Each place as `file:line` with one line on why:
   - **Critical**: code that decides query results (lowerings, pre/post-agg splits, partitioning and order properties, the order tag), the cost model (it shifts plan choice for every query), traits and helpers that many nodes share, wire types in `contracts/` and serialization, defaults and dev opts.
   - **Unusual**: a special case for one expression shape, `unsafe`, an `unwrap` on a reachable path, changed expected values in tests, deleted or skipped tests, a new dependency, global state, a pc-engine workaround for what is a polars OSS bug.

   Also pick the **pictures**: each new lowering, and each data flow that is hard to follow in prose (what a node becomes through the passes, how a value travels between stages, how two rewrites interact). One picture per subject; none when the PR has no such subject.

   Done when every hunk in scope is explained in step 2, listed here, or plainly routine.

4. **Send the reviewers.** Spawn the reviewers of [`reviewers.md`](reviewers.md) in one message, in the background: four subagents (correctness, tests, architecture, comments), or two when the scoped diff is under about 150 lines (correctness with tests, architecture with comments). Brief each with the explanation and attention list from steps 2–3, the diff command, the scoped file list, and the path of `reviewers.md` with the sections it must follow.

   Then post steps 2–3 to the user, who reads them while the subagents run.

5. **Verify every finding** yourself, in sequence; reviewers write no files, since parallel builds and compute planes collide.
   - **Bugs need a reproducer that goes red** on the PR's code.
     - if a reproducer that passes refutes its finding: drop both. Keep an unreproduced finding only when the code leaves no doubt, and label it unreproduced.
   - **Introduced or pre-existing**: check whether the faulty code is in the diff. A bug the PR moves or exposes is still reported, labelled pre-existing.
   - Drop findings that fail the verdict bar above.

   Done when every surviving finding has a red reproducer or a stated reason it has none.

6. **Report the verdict.** Lead with *approve*, *approve with comments* or *request changes*, and one sentence why. Then the findings, numbered so the user can pick them ("fix 1 and 3"), in the order you would want them solved. For each: severity (blocker, should fix, question), `file:line`, what goes wrong in plain words, the reproducer's path and what it showed, and the fix in a sentence. Then a short judgment of the architecture and of comment clarity, also when they are fine. End with what was not checked (tests not run, files outside the scope).
