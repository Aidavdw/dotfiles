---
name: prune-tests
description: "Clean up a sketch-phase test suite: remove duplicate, subset and implementation-detail tests, fold same-shape tests into parametrised ones, and keep (or add) explicit edge-case coverage of the public behaviour."
argument-hint: "[scope: a crate, directory, file or test module, or all the tests changed since a certain commit] (default: the tests changed on this branch)"
disable-model-invocation: true
---

Turn a pile of sketch-phase tests into a compact suite that tests **behaviour through the public API**.
The goal is not fewer tests for its own sake.
After the cleanup, every behaviour and every edge case that was covered is still covered,
each edge case is visible by name,
and a reader can see per case what goes in and what must come out.

## Guardrails

- Only touch test code and test helpers. If a test can only be written by changing non-test code (e.g. widening visibility), report it instead.
- Leave `HEAD`, the branch and the index alone: no `add`, `commit`, `reset` or `stash`. All changes stay unstaged, so the user reviews them with `git diff`.
- Never drop a regression test for a bug that was actually found. Look for it in the test name, a comment, or `git log -S<test name>`. Fold it into a parametrised test if it fits, but keep it as a named case.
- Don't introduce a test dependency (`rstest`, `proptest`, `hypothesis`, ...) that the project does not already have.

## Steps

1. **Find the scope.** The argument is the scope. Without one, take the tests added or changed on this branch compared to the branch it originates from.
   Run the tests in scope, and record which pass, and how many there are. If any fail before you start, stop and report.

2. **Map what is covered.** For every test in scope, write down in one line:
   - the **public behaviour** it exercises (the function, method, expression or CLI command a user calls),
   - the **input class** (normal case, empty, single element, null, boundary, error path, ...),
   - what it **asserts**, and whether that goes through the public API or reaches into internals.

   This gives a coverage map of behaviour × input class. Also note which cells of the map are empty for the edges in step 4.

3. **Classify every test** into exactly one of these:
   - **Duplicate**: same behaviour, same input class, same assertion as another test (also when the literal values differ but don't hit a different code path). Delete.
   - **Subset**: everything it asserts is implied by another test. A typical case is checking `len()` or one field while another test checks the full output for the same input. Delete.
   - **Implementation detail**: asserts on private fields, intermediate representations, internal call order, cache state, exact error message wording that is not a documented contract, or on how something is computed rather than what comes out. If the behaviour behind it is not covered elsewhere, rewrite it through the public API. Otherwise delete.
   - **Helper test**: tests an internal helper directly while the same behaviour is reachable through the public API. Move the cases that matter to a public-level test and delete it.
     Keep it only when the helper has real logic of its own (a parser, a numeric algorithm, a combinatorial rule) whose edge cases are much harder to hit or read through the public API. Say why in the report.
   - **Same-shape family**: several tests whose bodies differ only in inputs and expected outputs. Merge into one parametrised test (step 5).
   - **Keep**: a distinct behaviour or edge, already written well.

   For every test you delete, name the test that still catches its failure.
   If you cannot name one, it was not redundant: keep or rewrite it.

4. **Check the edges.** For each public behaviour in scope, check that the edges that apply to it have an explicit, named case:
   empty input, a single element, nulls / `None` / missing values, boundaries (0, 1, the maximum, off-by-one, overflow), duplicates, ordering and stability, non-ASCII strings, nested or unusual types, and each documented error path.
   Add the missing ones that apply. Skip those that cannot happen for this behaviour, without padding the suite to tick a box.

5. **Rewrite compactly.**
   - **Parametrise families** with the idiom the project already uses:
     `pytest.mark.parametrize` with readable `ids`,
     `rstest` `#[case::name]` when it is already a dependency,
     or otherwise a table of `(name, input, expected)` with a loop whose assertion message includes the case name.
     One parametrised test per behaviour, with the edges as named cases next to the normal ones.
   - **Assert the whole result** in one comparison (`assert_eq!` on the full output, `assert_frame_equal`, ...) instead of a series of partial assertions.
   - **Expected values are literals.** Never compute the expected value with the same logic as the code under test.
   - **Share setup, not meaning.** Extract fixtures, builders and assertion helpers when the same setup repeats in three or more tests.
     A reader must still see the input that matters and the expected output in the test or case itself, not behind a helper.
   - **Name tests after behaviour**: `filter_drops_null_rows`, not `test_filter_3` or `test_helper_inner`.
   - Keep error-path tests separate from the happy-path table when their assertion has a different shape (`pytest.raises`, `#[should_panic]`, `is_err()`).
   - Follow the existing layout of the test files. Don't move tests between files unless they are clearly in the wrong place.

6. **Verify.**
   - Run the tests in scope again. Everything passes, and no test is skipped that was not skipped before.
   - If the project already has a coverage tool set up (`cargo llvm-cov`, `pytest --cov`), compare line coverage of the code under test before and after. Any line that lost coverage is a regression: restore a case for it.
   - For each parametrised test, temporarily break one expected value and check that the failure message names the case. Revert afterwards.

## Report

- Test count before and after, and the number of cases.
- A table of what was removed or merged: test, category from step 3, and the test or case that covers it now.
- The edge cases you added.
- Helper tests you kept, and why.
- What you could not do within the guardrails (e.g. behaviour only reachable by widening visibility), and any coverage you could not confirm.
