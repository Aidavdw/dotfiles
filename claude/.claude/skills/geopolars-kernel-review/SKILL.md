---
name: geopolars-kernel-review
description: "Review a GeoPolars kernel: decide whether it is native or forwards to GEOS (or another library), then have focused subagents check it against the kernel guides, its helpers, its arguments and, for native kernels, the GEOS source."
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

3. **Send the reviewers.**
   Spawn the reviewers that apply in one message, in the background,
   as `general-purpose` subagents:

   | Reviewer | Native | GEOS | Other forwarding |
   |---|---|---|---|
   | Kernel pattern | yes | yes | yes |
   | Helpers | yes | yes | yes |
   | Arguments | yes | yes | yes |
   | GEOS comparison | yes | no | no |

   Brief each with the kernel path(s), the kind from step 2,
   the path of [`reviewers.md`](reviewers.md),
   and the sections it must follow (**Every reviewer** plus its own).

4. **Merge the findings.**
   Drop duplicates, and merge findings that two reviewers reached from different sides.
   Check a finding against the code yourself only when it is surprising,
   or when two reviewers contradict each other.

5. **Report.**
   Lead with the kind of kernel and a one-sentence judgement.
   Then the findings, numbered so the user can pick them ("fix 1 and 3"), most urgent first.
   For each: severity, `file:line`, what is wrong, and the fix in a sentence.
   End with what was not checked (e.g. a GEOS equivalent that could not be found, a fuzz test that could not run).
