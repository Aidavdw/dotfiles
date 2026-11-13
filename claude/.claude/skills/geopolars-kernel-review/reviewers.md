# Reviewer briefs

Each reviewer follows **Every reviewer** plus its own section.

## Every reviewer

- The repository is `~/geopolars`. Its `docs` folder holds the guides referred to below.
- **Read only.** Do not touch the repository or git.
  Scratch scripts (e.g. a fuzz test) go in `$TMPDIR`.
- **Stay in your lane.** Report only what your own section asks for;
  the other reviewers cover the rest.
- **Each finding**:
  - **Severity**: *should fix*, *consider*, or *question* (the author can decide what you cannot).
    **Helpers** also has *allowed*.
  - `file:line`.
  - **Claim**: one sentence.
  - **Evidence**: the code (or doc) that proves it.
  - **Fix**: one sentence.
- Report "nothing found" plainly when that is the result.

## Kernel pattern

Check if the kernel follows the standard pattern of `docs/Kernel implementation guide.md`,
and of the guide for its kind:
`docs/Native kernel implementation guide.md` for a native kernel,
`docs/GEOS kernel implementation guide.md` for a GEOS kernel.
Leave what they say on validity, NaN, empties and errors
(including "Vectorising simple kernels" in the native guide)
to **Missing values and errors**.

## Helpers

Review the helpers connected to the kernel:
the ones it defines, the ones it uses (from the views, shared modules or other kernels),
the ones other modules import from it,
and code elsewhere that duplicates its code.
Leave helpers you only pass on the way.

Much of the repository does not follow the rules below yet,
so a pattern found elsewhere does not excuse one here.
Naming, doc comments, upstream crates and tests are not yours to review.

### Where helpers belong

- **`geopolars-views`**: only what costs nothing:
  O(1) per call, without allocating or writing
  (accessors, ranges, spans, O(1) checks such as `is_ring`).
  Building a view (its constructors, and the trimming in `new` and `sliced`) belongs there too.
- **`geopolars-compute/src/utils.rs`**: every other shared helper, for native, GEOS or both,
  directly in that module, without sub-modules.
  This includes filters, and anything that loops over the coordinates, allocates or writes,
  such as `with_ranges_reversed`, `copy_ranges`, `gathered` and `with_null_at`, which are in the views now.
- **Shared infrastructure** that kernels are built on stays where it is
  (`per_row.rs`, `passing.rs`, `inner_nulls.rs`, `metric.rs`, `error.rs`, the GEOS conversion in `geos/mod.rs`).
  A small helper in one of those modules that is not part of its infrastructure belongs in `utils.rs`.
- **A kernel module** holds only helpers for that kernel alone.

### Duplication

This is your main job, so search thoroughly.
For each helper, and each piece of the kernel that could be one,
grep `geopolars-compute` and `geopolars-views` for its shape
(the calls and types it relies on, not its name),
and read the hits.
List what you searched for in your report.

- A helper, or inline code, that does what a view method or shared helper already does should use that.
- The same logic in two or more modules should be one helper in `utils.rs`.
  List every copy with `file:line`, also those outside this kernel.
- Copies that differ in a way that looks deliberate are a *question*,
  unless a comment already explains the difference
  (e.g. the empty point is x and y NaN for GEOS, but NaN on every axis for native).
- Code repeated within the module should become a helper.

### Imports between kernels

A kernel module should neither import a helper from another kernel module nor export one to it.
Check both ways.

The exception is a kernel's main thing:
the function that computes the kernel's own result for one item (row, part or ring),
so that the kernel is essentially a loop around it
(e.g. `area::twice_signed_area`, but not `rings::offsets_of`).
Report such an import too, as *allowed*, with a one-sentence reason against this test.
The orchestrator judges it.

Calling another kernel as a whole (e.g. `add_parts` using the `is_empty` kernels) is fine,
unless it pays for a whole pass to get a small piece of it.

### The helper itself

- **Necessity**: inline a helper that hides more than it clarifies:
  a one-line wrapper that only forwards to another function,
  one whose name says less than its body,
  or one that splits a loop so that its shape is harder to follow.
  A helper that names a step of the kernel stays, even with a single caller.
- **Visibility**: the narrowest that works.
- **Fit**: an existing helper that does not quite fit,
  e.g. one that forces a copy where a variant without one would do.
- **Allocation**: judge from the code; do not run benchmarks.
  Flag an allocation per row or per part, a `Vec` collected only to iterate over,
  copying a view only to reshape it, and a pass that only changes the type.
  Output buffers sized once (`SizeHint`),
  and one allocation per chunk to build a trimmed view, are fine.

### Severity and fix

- *should fix*: a copy of an existing helper, the same logic in two or more modules,
  an import between kernels, a helper in the wrong crate or module,
  an avoidable allocation, and a poor fit that forces an allocation.
- *consider*: code repeated within the module, visibility wider than needed,
  an unnecessary helper, and a poor fit that costs no allocation.
- *question*: copies that seem to differ on purpose,
  and an allocation that may be a deliberate trade-off.
- *allowed*: a kernel's main thing, imported by another kernel.

A fix that moves a helper names its destination and every caller that changes.

## Arguments

Follow the kernel's arguments up through the plugin layer to the Python API
(see `docs/Typical expression flow.md`), and review them there.
Check that the right arguments are there;
whether they behave as documented at runtime is for **Missing values and errors**.

### Common arguments

The expressions must use the 'common arguments' if possible,
rather than re-defining new ones in slightly different words.
They are described in `docs/Common arguments.md`.
An argument it lists as *Legacy* should not be used in new code.

### Some arguments imply another argument also being required

Any function that can remove points must also always take the `short_lines` argument,
as dropping parts can make rings and linestrings too short.
This means that any constructor that takes the `null_parts` argument must take it too.

Make sure that a kernel that takes a polygon (or multipolygon) and the
`short_lines` argument also takes an `empty_polygon_exterior` argument,
as anything that removes points from a ring can otherwise invalidate a polygon.

Any function that takes `new_ring_orientation` must also take `new_holes`,
if it can output a polygon.

Any function taking the `promote_to_multi` argument must also take the `on_row_error` argument,
as with `"never"`, a result with several parts raises an error here.

Any function taking `early_coord_check` also requires `on_row_error` due to handoff.

Any function taking `empty_polygon_exterior` must also take `on_row_error`,
as `empty_polygon_exterior="error"` hands the error to it.

### `new_ring_orientation` on GEOS kernels

Only for GEOS kernels.
If the kernel has a `new_ring_orientation`, fuzz test with Shapely to see if the operation always gives the standard GEOS orientation (per `docs/GEOS kernel implementation guide.md`).
Report the inputs you tried, and any that broke the standard orientation.
Run geopolars with `~/geopolars/.venv/bin/python`;
your brief says whether the build succeeded.

## Missing values and errors

Check that the kernel handles nulls, NaN, empties and errors the same way as the other kernels.
Judge it against, in this order:
1. The docs: `docs/Kernel implementation guide.md` (validity, NaN, empties and errors),
   the guide for its kind, `docs/Common arguments.md`,
   the validity table in `README.md`, and `docs/Tier per expression.md`.
2. The shared helpers: `per_row.rs`, `row_or_null` in `error.rs`,
   `native/coordinate_selection.rs`, and `GeosRow` in `geos/mod.rs`.
   A kernel that hand-rolls what one of them does should use it.
3. Two or three sibling kernels of the same kind that take the same arguments.
   Name the ones you compared against.
   Where they disagree among themselves, report a *question* rather than picking one.

The code may still use the legacy `ignore_per_row_errors` and `early_finite_check`:
read them as `on_row_error` and `early_coord_check`.
Their naming is for **Arguments**.

### Method

Read the code first.
Whenever you suspect something is off, confirm it by running the expression on a small input
with `~/geopolars/.venv/bin/python`,
and put the input and output in the evidence.
Your brief says whether the build succeeded.
Without a build, report from the code alone, and tag the finding **unverified (no build)**.

### Valid input

Assume valid GeoArrow: only the outer level may be null,
so do not report missing handling of nested nulls.
The exception is constructors and sanitising functions:
kernels that take `null_parts` or `check_null_coordinates`,
or that build geometries from parts or coordinates.
For those, nested nulls and invalid input are in scope.

NaN, inf and empties (the empty point, which is NaN on every axis, and empty rings and parts)
are valid GeoArrow, and always in scope.

End your report with one line: "Constructor rules: applied / not applied, because …".

### Shared

- **Nulls first.** Before doing any work,
  the kernel returns an all-null result when `null_count() == len()`,
  and takes the `ALL_VALID` path when `null_count() == 0`.
- **Fail as early as possible.** For every error the kernel can raise,
  find the earliest point it could be raised:
  at plan time (follow the argument up to the plugin layer, per `docs/Typical expression flow.md`),
  otherwise before the loop over the rows,
  and only otherwise inside it.
  An error raised later than it could be is *should fix*.
- **Row errors are per row.** An error caused by one row goes through `on_row_error`:
  `"raise"` returns it, `"null"` nulls that row and no other.
  Flag a row error that fails the whole column regardless
  (e.g. `?` inside `per_row`, which fails the whole chunk).
- **No silent nulls.** A row becomes null only when its input is null,
  or when `on_row_error="null"` handles its error.
  Flag `.ok()`, `unwrap_or_default()`, `Err(_) => None` and the like
  that turn an error into a null or a default value without going through `on_row_error`.
- **NaN, inf and empties.** Check what the kernel gives for a NaN axis, an inf coordinate,
  an empty point, and an empty ring or part,
  and that this matches the docs and the siblings.
- **Panics.** Any panic reachable from valid input (from any input, for constructors) is *should fix*:
  `unwrap`, `expect`, indexing, overflow,
  or dividing by a count that is zero for an empty geometry.
  `debug_assert!` is fine, and so is `unreachable!` when validity guarantees the invariant.

### Native

Only for native kernels.

- **Vectorising** (see "Vectorising simple kernels" in `docs/Native kernel implementation guide.md`).
  Computing over `ignoring_validity()` and masking afterwards
  is only allowed when the computation is harmless on arbitrary values:
  no panics, no errors, no indexing with them.
  Otherwise the branchless route must be limited to inputs without nulls.
  Empties that need fixing up get a separate branchless bitmap pass, not a branch in the loop.
  A flat kernel that could be branchless, but checks for nulls or empties in the loop, is a *consider*.
- **Dispatch.** `early_coord_check`, `null_parts`, `ALL_VALID` and `IGNORE_NAN`-style flags
  are dispatched through const generics;
  `on_row_error` is checked at runtime.
- **`early_coord_check`** defaults to `"finite"`, and runs as its own pass before the loop.

### GEOS

Only for GEOS kernels.

- **Short-circuit.** Null and empty rows become `GeosRow::Null` and `GeosRow::Empty`,
  and never reach GEOS.
  For a binary operation, a null or empty on either side short-circuits.
- **`early_coord_check`** defaults to `"finite_and_empty"`,
  and runs during the conversion to GEOS.
- **GEOS errors** go to `on_row_error` (e.g. through `row_or_null`), never straight to null.
- **Check turned off.** If the coordinate check can be turned off,
  the module documents what GEOS does with non-finite input then,
  as `geos/convex_hull.rs` does.

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
