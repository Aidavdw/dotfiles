---
name: geopolars-kernel-review
description: "Review a GeoPolars kernel: decide whether it is native or forwards to GEOS (or another library), then have focused subagents check it against the kernel guides, its helpers, its arguments, its handling of nulls, NaN and errors and, for native kernels, the GEOS source."
argument-hint: "[kernel: a module in geopolars-compute, or the name of an expression]"
---

Review one kernel of `geopolars-compute`.
You are the orchestrator: you find and classify the kernel, send the reviewers, and merge what they report.
Leave the reading to the reviewers, so that your own context stays small.

## Steps

1. **Find the kernel.**
   The user names a module in `geopolars-compute/src` or an expression.
   For an expression, find the kernel module(s) it calls.
   Ask when it is ambiguous.

   Done when you have the path of every kernel module in scope.

2. **Classify each kernel** by where it lives and what its loop calls:
   - **Native**: in `geopolars-compute/src/native`, computing the result itself.
   - **GEOS**: in `geopolars-compute/src/geos`, converting to GEOS and calling it.
   - **Other forwarding**: in `rsgeo` or `proj`, forwarding to those libraries.

   A native module that hands (some of) its work to GEOS is GEOS for that part.
   An expression with both a native and a GEOS kernel gets the reviewers of both kinds.
   Say which kind you picked and why, in one line.

3. **Start a debug build** with `make install` in `~/geopolars`, in the background.
   It goes through `uv sync`, which may need the network,
   so run it outside the sandbox (this asks the user).
   Do not use `make test`: it builds the same, but then runs the whole test suite too.

4. **Send the reviewers** that apply, in the background, as `general-purpose` subagents:

   | Reviewer | Native | GEOS | Other forwarding | Needs the build |
   |---|---|---|---|---|
   | Kernel pattern | yes | yes | yes | no |
   | Helpers | yes | yes | yes | no |
   | Arguments | yes | yes | yes | only for its `new_ring_orientation` fuzz test |
   | Missing values and errors | yes | yes | yes | yes |
   | GEOS comparison | yes | no | no | no |

   Spawn the ones that do not need the build at once, in one message.
   Spawn the others when the build has finished, and tell them whether it succeeded.

   Brief each with the kernel path(s), the kind from step 2,
   the path of [`reviewers.md`](reviewers.md),
   and the sections it must follow (**Every reviewer** plus its own).

5. **Merge the findings.**
   Drop duplicates, and merge findings that two reviewers reached from different sides.
   Check a finding against the code yourself only when it is surprising,
   or when two reviewers contradict each other.

6. **Report.**
   Lead with the kind of kernel,
   the "Constructor rules" line from **Missing values and errors**,
   and a one-sentence judgement.
   Then the findings, numbered so the user can pick them ("fix 1 and 3"), most urgent first.
   Findings tagged **unverified (no build)** come first, in a section of their own.
   For each: severity, `file:line`, what is wrong, and the fix in a sentence.
   End with what was not checked
   (e.g. a GEOS equivalent that could not be found, a fuzz test that could not run, a build that failed and why).
