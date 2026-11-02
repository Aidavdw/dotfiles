# Reviewer briefs

Each reviewer follows **Every reviewer** plus its own section.

## Every reviewer

- **The question is approval.** Report what would make the user withhold approval or ask for a change, and what a future reader of the code would get wrong. Style, cosmetics, micro-performance and personal conventions (helpers after callers, `PlSmallStr` via `.into()`, doc-comment mood) are out of scope.
- **Read past just the diff**: callers, the traits a change implements, the neighbouring code that does the same thing.
- **Read only.** Write no files and leave git alone: `HEAD`, the branch and the index are the user's review state.
- **Organise by urgency**, the ones that matter most. Each one:
  - **Severity**: *blocker* (wrong result, crash, or a design costly to undo), *should fix* (approve, but ask for it), or *question* (the author can decide what you cannot).
  - `file:line`.
  - **Claim**: one sentence.
  - **Failure scenario**: concrete input or state, and the wrong output, crash or misreading it leads to.
  - **Evidence**: the code that proves it.
- Report "nothing found" plainly when that is the result.

## Correctness

Find bugs: wrong results, panics, lost order, unsoundness, incorrect assumptions or invariants.

- Try the edges: nulls, empty partitions and groups, everything filtered out, `k = 0`, a literal versus a column argument, list and nested dtypes, a single partition, the order tag on and off (dev opt `allow_order_tag`).
- Check each precondition a new branch relies on: is it checked where it is relied on, or only in some other function?
- Draft a reproducer for each bug. Try to match the testing philosophy of the repository, and model them off of existing tests.

## Tests

- Does each new behaviour have a test, and do the tests cover the edges listed under **Correctness**?
- Would each new regression test fail without the change? Reason it through on the code before the PR.
- Does each test check the property it is named for?

## Architecture

Judge whether the change has the right structure, and say so even when it does.

- **Generality**: a special case for one expression shape where a general rule would cover it and its siblings.
- **One source of truth**: a second mechanism beside an existing one, the same decision made in two places, an invariant one function checks and another relies on.
- **Surface**: visibility widened or a shared API changed, and whether the reason holds. Generic structures (`StageGraph`) stay generic; feature-specific matchers belong in test helpers.
- **Fit**: does it solve the problem the way the neighbouring code solves the same one?

## Comments and naming

The bar is the `comments` skill (`~/.claude/skills/comments/SKILL.md`)
, sections "The one test" and "Never write these"):
a comment says what the code cannot. Report:

- a comment that is wrong, stale, or easy to misread;
- a non-obvious mechanism, invariant or choice with no *why*;
- a term used without saying what it means here ("infallibly");
- a name that says something other than what the thing does.

Phrasing preferences (imperative mood, word choice) are out of scope. Give the replacement text for each finding.
