---
name: rebase
description: "Rebase the current branch onto another, asking the user about every conflict that matters, then build and test the result and report everything noteworthy."
argument-hint: "[onto: the branch or ref to rebase onto] (default: ask)"
disable-model-invocation: true
---

Rebase the current branch onto the ref the user names.
Port every commit faithfully, ask the user about anything that does not port over cleanly,
test the result, and finish with a report.

## Sandbox

You run in a sandbox that blocks every write to `.git`.
Each git command that writes (`git rebase`, `git branch`, `git add`) must run with `dangerouslyDisableSandbox: true`,
which asks the user for approval every time.
Run everything else (reading git state, building, testing) inside the sandbox.

`git reset`, `git stash`, `git checkout`, `git switch`, `git fetch` and `git push` are denied.
Do not try to work around that:

- resolve conflicts by editing the files, never with `checkout --ours/--theirs`;
- when the user needs to fetch, ask them to run `! git fetch <remote>`;
- never push, and never suggest a force-push.

Tests that need the network (e.g. `uv` installing packages) fail in the sandbox.
Ask before running them unsandboxed.

## Steps

1. **Check the starting state.**
   - Stop if a rebase, merge or cherry-pick is already in progress, or if `HEAD` is detached.
   - Stop and ask the user to commit or clean up if the working tree or index is dirty.
     Never use `--autostash`.
   - Stop and ask if the branch contains merge commits.
     This skill only does a plain linear rebase:
     no `--rebase-merges`, `--autosquash` or interactive squashing.

   Done when the tree is clean and the branch is linear.

2. **Settle `onto`.**
   If the user named a ref, use it.
   Otherwise never pick one yourself:
   ask, with as candidates the branch this one forked off
   (the branch, other than this one or its remote copies,
   with the fewest commits from `git merge-base HEAD <branch>` to `HEAD`, skipping branches at 0),
   its remote copies, and the repo's default branch.
   For each candidate, show its last commit date and how many commits it is ahead of the merge base,
   so a stale ref stands out.
   If the user wants to fetch first, ask them to run `! git fetch <remote>`.

   Done when the user has confirmed the ref.

3. **Make the backup branch.**
   Record the old `HEAD` SHA and create `<branch>-unrebased` at it with `git branch`.
   If that branch already exists, stop and ask:
   overwrite it, use `<branch>-unrebased-2` (or the next free number), or abort.
   The backup branch stays after the rebase, so the user can compare and revert.

4. **Rebase.**
   Run `git rebase <onto>`.
   On every stop, inspect the conflict before touching anything:
   `git diff`, the upstream commits that changed the same lines (`git log <merge base>..<onto> -- <file>`),
   and what this branch's commit meant to do.

   **Resolve silently** only the mechanical cases:

   - imports and `use` lists;
   - renames and moved paths, including adapting this branch's code to an API that upstream renamed;
   - formatting and whitespace;
   - independent additions that happen to sit next to each other,
     such as two new enum variants, match arms, test cases or changelog lines;
   - lock files (`Cargo.lock`, `uv.lock`): take upstream's version and let the build regenerate it.

   **Ask the user** in every other case:
   when both sides change the same logic, behaviour, signatures, test expectations or defaults,
   when a commit becomes empty or partly redundant because upstream already has the change,
   and whenever you are unsure which case applies.
   Ask once per commit, covering all its hunks that need a decision in one message.
   Number each hunk, and give upstream's side, this branch's side, and a proposed resolution with your reasoning,
   so the user can answer like "1 yes, 2: keep mine".

   After resolving, `git add` the files and run `git rebase --continue`.
   Keep a log of every resolution, silent or not, for the report.
   If the user wants to give up, run `git rebase --abort`.

   Done when the rebase has finished.

5. **Build and test.**
   Find the repo's build and test commands in its `CLAUDE.md`, `Makefile`, or equivalent.
   - Build or check the whole workspace (e.g. `cargo check --workspace --all-targets`).
     A commit that applied cleanly but no longer compiles is a semantic conflict:
     fix it if it is mechanical (as in step 4), otherwise ask.
   - Run the tests for the crates and Python modules the branch touches.
     Run the full suite only if the user asks.

   When tests fail, report them and ask before fixing anything.
   Say for each failure whether it is in code this branch touches,
   or looks like it already fails upstream.
   You cannot check out `onto` to prove the latter, so label it as a judgement.
   Never commit fixes without the user's go-ahead.

6. **Report.**
   Give a short report in the terminal containing:

   - the old and new `HEAD`, the backup branch,
     and how to revert: `git reset --hard <branch>-unrebased` (for the user to run);
   - how many upstream commits came in;
   - every conflict, and how it was resolved: by the user or silently, and why;
   - commits that were dropped or became empty;
   - semantic adaptations, such as renamed APIs or changed signatures;
   - upstream changes that touch the same functions as this branch without conflicting,
     since those are where silent breakage hides;
   - build and test results, with failures split into "likely ours" and "likely upstream";
   - the commands to compare old and new:
     `git range-diff <onto>...<branch>-unrebased <onto>...HEAD`
     and `git diff <branch>-unrebased HEAD -- <files the branch touches>`;
   - any commit whose range-diff shows changes beyond the conflict resolutions;
   - anything the user should double-check before pushing.

   Leave out what is unremarkable: a section with nothing to say gets no heading.
