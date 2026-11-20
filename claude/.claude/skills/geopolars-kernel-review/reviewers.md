# Reviewer briefs

Each reviewer follows **Every reviewer** plus its own section.

## Every reviewer

- The repository is `~/geopolars`. Its `docs/source/development` folder holds the guides referred to below:
  `kernel-implementation-guide.md` (the *general* guide),
  `native-kernel-implementation-guide.md` (the *native* guide),
  and `geos-kernel-implementation-guide.md` (the *GEOS* guide).
  The common arguments are in `geopolars/docs/source/reference/common_arguments.rst`.
- **The guides are the authority** on how a kernel should be written,
  not the code around it.
  Read "The target, and legacy names" in the general guide first:
  the code may still use the legacy names, which are not findings in themselves.
  A legacy argument name is for **Arguments** alone.
  Where the guides do not cover something you came across, report a *question*:
  "the guides do not say …".
- **Review only this kernel.** Do not report the same problem in other kernels.
- **Read only.** Do not touch the repository or git.
  Scratch scripts (e.g. a fuzz test) go in `$TMPDIR`.
- **Stay in your lane.** Report only against the guide sections your own section lists.
  Every rule in the guides belongs to exactly one reviewer, so another reviewer covers the rest.
  Docs and comments are not reviewed, unless a section you own asks for one.
- **Each finding**:
  - **Severity**: *should fix*, *consider*, or *question* (the author can decide what you cannot).
    **Helpers** also has *allowed*.
  - `file:line`.
  - **Rule**: the guide and section it breaks.
  - **Claim**: one sentence.
  - **Evidence**: the code (or doc) that proves it.
  - **Fix**: one sentence.
- Report "nothing found" plainly when that is the result.

## Kernel pattern

You own:

- general guide: "The entry point" (with "Work on the arrays, not on single items"),
  "Dispatch" (with "Const or runtime branching"), "Passes and allocation",
  "Trimmed and untrimmed views", and "Backends".
- native guide: "Shapes", "Points and nested kinds", and "Vectorising simple kernels",
  except whether a computation is harmless under a null,
  which is "Nulls" in the general guide.
- GEOS guide: "Shapes", and "One container for GEOS geometries".

### Method

1. **Shape.** Name the shape of the kernel from the guide for its kind,
   and the module the guide names as closest.
   PROJ has the native shape "Rewriting the coordinates".
   If no shape fits, that is a *question*.
2. **Diff.** Compare the kernel against the sketch of its shape, rule by rule:
   entry points, dispatch, the loop, and how the output is built.
   The closest module is only there to orient you; it may itself be off.
3. **Rules.** Go through every rule of the sections you own,
   and list each one as *passes*, *fails* or *n/a*, with a few words on why.
   Put this list in your report, before the findings.
4. **Dispatch chain.** Follow each argument of the kernel from the plugin (`geopolars/src/expr/`),
   through `geopolars-core`, to the loop,
   and check every step against "Dispatch".
5. **Helpers.** Read every helper the kernel calls,
   but only for "Passes and allocation":
   a helper may be a poor fit because it has to allocate.
   Everything else about helpers is for **Helpers**.

Judge allocation from the code; do not run benchmarks.

### Severity

- *should fix*: a broken rule.
  This includes an `Untrimmed` view whose kernel walks a whole level.
- *consider*: a flat kernel that could be branchless, but checks for nulls or empties in the loop.
- *question*: a trimmed view that the kernel only reaches through the offsets of its rows
  (whether the trim matters needs a benchmark),
  an allocation that may be a deliberate trade-off,
  and anything the guides do not cover.

## Helpers

You own: general guide, "Helpers".

Review the helpers connected to the kernel:
the ones it defines, the ones it uses (from the views, shared modules or other kernels),
the ones other modules import from it,
and code elsewhere that duplicates its code.
Leave helpers you only pass on the way.
What a helper allocates is for **Kernel pattern**.
Naming, upstream crates and tests are not yours to review either.

### Duplication

This is your main job, so search thoroughly.
For each helper, and each piece of the kernel that could be one,
grep `geopolars-compute` and `geopolars-views` for its shape
(the calls and types it relies on, not its name),
and read the hits.
List what you searched for in your report.

- A helper, or inline code, that does what a view method or shared helper already does should use that.
  Check these shared helpers in particular:
  `per_row.rs`, `row_or_null` in `error.rs`, `native/coordinate_selection.rs`, and `GeosRow` in `geos/mod.rs`.
- The same logic in two or more modules should be one helper in `utils`.
  List every copy with `file:line`, also those outside this kernel.
- Code repeated within the module should become a helper.

### Imports between kernels

Check both ways: what the kernel module imports from other kernel modules, and what they import from it.
Report an import of a kernel's main thing (as the guide defines it) as *allowed*,
with a one-sentence reason against that definition.
The orchestrator judges it.
Calling another kernel as a whole (e.g. `add_parts` using the `is_empty` kernels) is fine,
unless it pays for a whole pass to get a small piece of it.

### Severity and fix

- *should fix*: a copy of an existing helper, the same logic in two or more modules,
  an import between kernels, and a helper in the wrong crate or module.
- *consider*: code repeated within the module, visibility wider than needed,
  an unnecessary helper, and a helper that does not quite fit.
- *question*: copies that seem to differ on purpose, without a comment saying why.
- *allowed*: a kernel's main thing, imported by another kernel.

A fix that moves a helper names its destination and every caller that changes.

## Arguments

You own: `common_arguments.rst`, and the GEOS guide's "Orientation of new rings".

Follow the kernel's arguments up through the plugin layer to the Python API
(see `docs/source/development/typical-expression-flow.md`), and review them there.
Check that the right arguments are there, with their common names,
and that every argument "Arguments that come together" asks for is there too.
An argument marked *Legacy* should not be used in new code.
Whether the arguments behave as documented at runtime is for **Missing values and errors**,
and how they reach the loop is for **Kernel pattern**.

### `new_ring_orientation` on GEOS kernels

Only for GEOS kernels.
If the kernel has a `new_ring_orientation` (or the legacy `ccw_outer`),
fuzz test with Shapely to see if the operation always gives the standard GEOS orientation,
as "Orientation of new rings" describes it.
Report the inputs you tried, and any that broke the standard orientation.
Run geopolars with `~/geopolars/.venv/bin/python`;
your brief says whether the build succeeded.

## Missing values and errors

You own:

- general guide: "Valid input" (with "NaN, infinity and empties"), "Nulls", "Errors", and "MaskedParts".
- native guide: "`early_coord_check`".
- GEOS guide: "Trivial rows never reach GEOS", and "Coordinate checks and GEOS errors".

Besides the guides, what an expression should give is in `common_arguments.rst`,
the validity table in `docs/source/user-guide/geo/concepts/validity.md`,
and `docs/source/development/tier-per-expression.md`.
A kernel that hand-rolls what a shared helper does is for **Helpers**.

### Method

Read the code first.
Whenever you suspect something is off, confirm it by running the expression on a small input
with `~/geopolars/.venv/bin/python`,
and put the input and output in the evidence.
Your brief says whether the build succeeded.
Without a build, report from the code alone, and tag the finding **unverified (no build)**.

Always check what the kernel gives for a NaN axis, an inf coordinate,
an empty point, and an empty ring or part.

For every error the kernel can raise, find the earliest point it could be raised
(follow the argument up to the plugin, per `docs/source/development/typical-expression-flow.md`).
An error raised later than it could be is *should fix*.

### Constructors

"Valid input" in the general guide names the kernels that may get invalid input.
For those, nested nulls and invalid input are in scope;
for every other kernel, do not report missing handling of nested nulls.

End your report with one line: "Constructor rules: applied / not applied, because …".

### Severity

- *should fix*: a broken rule, including any panic reachable from input the kernel may get.
- *question*: a result for NaN, inf or an empty that the docs do not pin down.

## GEOS comparison

Only for native kernels.

### Compare the numerical implementation to that in GEOS

Try to find if this expression has a GEOS equivalent.
GEOS is a very stable and battle-tested library.
It will probably have a lot of very specific checks for numerical checks and ways of calculating things.
Floats can be very finicky, so sometimes a 'simple multiplication' cannot be a
'simple multiplication' because of some numerical instabilities or subnormal numbers.
Compare how we do the actual calculation with how it is done in GEOS.
Look at the GEOS source code for this (it is not checked out locally; read it on GitHub, `libgeos/geos`).
If something is much more complicated there, it is probably for a reason.
Try to figure out what that reason is.
Then try to answer the question "Do we adequately guard for it here in our native kernel too?"

Name the GEOS files and functions you compared against.
If there is no GEOS equivalent, say so, and stop there.
