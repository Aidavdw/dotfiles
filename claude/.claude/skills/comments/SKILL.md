---
name: comments
description: Rules for writing code comments and doc comments, for deciding whether an item needs a doc comment and how long it may be, and for naming functions. Use whenever you write, edit or review a comment, doc comment or module doc, or name a function. The core question is whether a comment conveys something the code cannot.
---

Only add comments that actually add something.

## The Golden Rule

The golden rule to ask yourself is: "Does the comment convey something the code cannot?"
Everything else should follow from this.

The answer is **yes** to cases where a comment is needed.

- a non-obvious mechanism, invariant or choice with no *why*;
- a name that says something other than what the thing does.

## Whether to write a doc comment, and how much

Decide this before writing anything.
Most doc comments that go wrong should not have been written,
or got far more lines than the item deserves.

### The gate

A **public** item always gets a doc comment,
unless its name and signature already make it fully clear what it does.
Public means reachable from outside the crate or package.
`pub(crate)` and `pub(super)` are internal.

An **internal** item gets no doc comment,
unless at least one of these holds:

- **Signature:** an argument or const generic whose role a reader cannot tell from its name and type,
  and a better name cannot fix that.
  Think of a flag, or an `Option` whose `None` means something unconventional.
- **Reuse:** it is called from 3 or more places, or from another module,
  so readers reach it without the context of its caller.
- **Body:** the body is longer than about 20 lines,
  and the name cannot capture what it does.
- **Regardless of size:** the caller must uphold a precondition (`unsafe`, equal lengths),
  or it behaves differently from what its name suggests.

If your function is named something like `do_action_for_polygons`,
a doc comment like `/// Performs an action [Action] for every polygon`
does not add any information.
Leave such a function without a doc comment.

### The budget

How much a doc comment may say depends on how important the item is.
A helper or small API function should never get more lines than the function it serves.

| Tier | What it is | Budget |
|---|---|---|
| User-facing | What end users call and read in the published docs, e.g. the Python API | No cap. Covers behaviour, every parameter, errors, and examples |
| Main | The item the module is named after, or exists for | A summary, plus up to about 6 sentences |
| Secondary | Other public items, and internal helpers that pass the gate through reuse | A summary, plus at most 2 sentences |
| Helper | Internal helpers that pass the gate through their signature or body | 1 to 2 sentences in total, about what made it pass the gate |

A large item moves up one tier (but never into User-facing)
if its body is longer than about 50 lines,
or it takes more than about 5 inputs (arguments plus const generics).
It moves up at most once.

A doc comment is never longer than the doc of the function it serves,
unless it was moved up a tier.
A thin wrapper around such a large helper refers to it with `see [helper]`,
and only says what it does differently.

Within a budget, keep what the caller is most likely to trip over:
preconditions first, then surprising behaviour, then error cases.
Drop edge cases that follow from the domain,
like a buffer of distance 0 around a point being empty.

### Invariants

A public item always states the invariants the caller must uphold.
These do not count towards the budget.
If an invariant is already documented on a type or function the doc links to,
link to it instead of restating it.

A helper neither restates nor links the invariants it inherits from its caller.

### Bindings to user-facing functions

The user-facing doc is the source of truth.
A function that only binds a user-facing one simply refers to it,
e.g. "Implements the Python `buffer`."
A function that does more than bind does not restate the user-facing behaviour either.
It refers to the user-facing function, and then adds what its own caller needs,
usually preconditions and the shape of its input and output.
Pick its tier as if the user-facing behaviour did not exist.

For example, before:

```rust
/// Every row buffered by `distance`, forwarded to GEOS, as a polygon.
/// A NaN or infinite distance fails like a GEOS error,
/// as does a negative one with a single `side`.
/// This is for a point, linestring or polygon.
/// A distance of at most 0 gives an empty polygon for a point or linestring.
/// A negative distance shrinks a polygon.
/// A row that GEOS buffers into several polygons fails like a GEOS error.
/// For a single kind, that only happens with a negative distance.
/// If `ignore_per_row_errors=true`, a row GEOS fails on is null;
/// otherwise its error is returned.
/// If `ccw_outer=true`, every ring is reversed, so the exterior runs counter-clockwise.
/// Otherwise it runs clockwise, as GEOS gives it.
pub fn buffer_into_polygons(
    array: &impl ToGeosRows,
    distance: BufferDistance,
    style: &BufferStyle,
    ccw_outer: bool,
    ignore_per_row_errors: bool,
    early_finite_check: bool,
) -> GeoComputeResult<PolygonArray> {
```

Problems: this is a public helper with one caller, but it gets twelve lines of separate facts.
Almost all of them restate the docstring of the Python `buffer`, which it implements.

After:

```rust
/// Buffers every point, linestring, or polygon into a polygon through GEOS.
/// Implements the Python `buffer` with `allow_splitting=false`, which documents its behaviour.
/// So a row that GEOS splits into several polygons fails, see [buffer_into_multi_polygons] to keep them.
```

User-facing docstrings follow the project's docstring convention for their structure
(e.g. numpydoc sections, or shared `@doc` snippets).
There, a `Parameters` section with one entry per argument is expected.

### Types, fields, trait items, and accessors

Types use the same gate and tiers as functions.

A field gets a doc comment only for what its name and type cannot carry:
a unit, an invariant between fields, or a `None` that means something unconventional.
One sentence at most.

Trait items (required methods, associated consts) count as public, whatever their visibility,
as they are a contract for every implementor.
They get the Secondary budget.
Say what the implementor must guarantee, not why the trait was designed this way.

Getters and setters never get a doc comment of their own.
If the field is public, the accessor refers to the field.
If the field is not public (outside the crate) but the accessor is,
the field's sentence lives on the accessor instead.
It should then not name the field, as that is not part of the API.

## Doc comments explain, they do not enumerate

A doc comment is a short piece of guiding text for the caller,
not a list of every fact you know about the function.

### Fix the names first

Before writing a doc comment, look at the function and argument names.
If you need a sentence to explain what an argument is, rename the argument instead.
`base` and `added` need explaining. `base_geometry` and `parts_added` do not.
If the summary you are about to write is a better description than the function name,
then the function name should change. `concatenated` becomes `concatenate_parts_onto_geometry`.

### Open with what the function does

The first sentence says what the function *does*, in terms of the domain.
It is also the summary rustdoc shows in listings, so it has to stand on its own.
Do not open with an argument name, or with a description of the output's layout.
"Every row of `base`, followed by the items on the same row of `added`." describes the result
and throws two argument names and a new term at the reader before they know what is going on.
"Performs a per-row concatenation of parts onto a base geometry." tells them.

### Each sentence follows from the previous one

Read the comment top to bottom: every sentence should build on the one before it.
If you could shuffle the lines without losing anything, you wrote a list of facts, not an explanation.
Common causes:

- A line that only defines a term from the previous line.
  Fold it into that sentence instead, e.g. as a bracketed aside:
  "parts (the rings of a polygon, or the linestrings of a multilinestring)".
- One line per argument. Describe arguments where they matter for what the function does,
  and group the ones that play the same role.
- A consequence or special case written as a separate statement.
  Tie it to the sentence it follows from with "so", "only", or "unless",
  e.g. "Only the parts set in `base_keep` and `parts_keep` are kept, so without `parts_added` this only filters `base_geometry`."
  If it follows so obviously that the reader would work it out anyway, drop it.

Order the sentences as: what it does, then behaviour the caller would not expect,
then what the caller must guarantee (equal lengths, matching dimensions).
Separate the preconditions with a blank line.

```rust
/// Performs a per-row concatenation of parts
/// (the rings of a polygon, or the linestrings of a multilinestring)
/// onto a base geometry.
/// Only the parts set in `base_keep` and `parts_keep` are kept,
/// so without `parts_added` this only filters `base_geometry`.
///
/// `base_geometry` and `parts_added` must have the same length and dimension.
/// `output_validity` must mark every null row of `base_geometry` as null.
pub(super) fn concatenate_parts_onto_geometry<const N: usize>(
    base_geometry: Nested<N>,
    base_keep: Option<&Bitmap>,
    parts_added: Option<Nested<N>>,
    parts_keep: Option<&Bitmap>,
    output_validity: Option<Bitmap>,
) -> Built<N> {
```

"Prefer short sentences" still applies.
Short sentences are fine. Disconnected sentences are not.

In function docs, don't chain "the X of Y of Z". Split it up, but keep it inside a sentence about what the function does
Try to not have sentences that are 80% variable names like "`arg1`, where `value_1` is lower than `value_2`". Instead, try to group them together. "Filters `arg1` that have a property `value_1 < value_2`".

### Don't document conventions

Don't spell out behaviour every reader already expects.
A `None` or null contributes nothing, empty input gives empty output, and so on.
That is the whole point of passing an `Option`, and it means the same thing everywhere.
So "A null row of `parts_added` adds nothing." can go.
Only document it when the function deviates from the convention.

### Say what an argument does to the result

When a sentence mentions an argument, the reader must come away knowing what effect it has.
"The rows are null where `validity` says." and "The output is null where `validity` is unset."
name the argument, but leave the reader guessing what it is and where it comes from.
Usually a better name fixes this: `output_validity` needs no sentence at all.
If you cannot state an argument's role plainly, read the code until you can.

Naming arguments is fine when the sentence is about them, as in a precondition:
"`base_geometry` and `parts_added` must have the same length and dimension."

### Behaviour first, then the argument that changes it

Describe the default case first, then the argument that changes it.
If the default is self-evident, only describe the deviation.
"If `listed=true`, `parts` holds a list of parts per row, otherwise one."
leads with the non-default case and hides the default behind "otherwise".
That a list holds multiple parts is self-evident, so only the deviation is left:
"`parts` only holds a single part per row if `listed=false`."
If a boolean still needs a sentence to explain what it switches,
see if a better name makes the sentence unnecessary.

When an argument interacts with behaviour that needs explaining,
explain that behaviour first, and then how the argument affects it.
Don't write "With `kwargs=`[EmptyParts::Drop], an empty single geometry is dropped like an empty part,
as it becomes the first part of the result."
Write "A single base geometry is turned into a Multi* geometry.
It is therefore also affected by `kwargs=`[EmptyParts::Drop]."

Constructions like "If X, Y, otherwise Z" and "With X, Y, as Z" pack several statements into one indirect sentence.
Prefer direct sentences with fewer commas, even if that means writing one more sentence.

### Only what the caller needs

Leave out how the function does its work (buffer layout, how many copies it makes, internal helper types),
unless the caller has to act on it.
"The vertices are copied into new buffers, two slices per axis per [CopiedVertices]." is such a line.
This holds for internal functions too: the reader of a doc comment is the person calling the function.
A public doc comment in particular is part of the user contract,
so internal values and mechanisms do not belong in it.
If the implementation needs explaining, put a regular comment in the body.

### Check before you finish

Re-read every doc comment you wrote and ask:

1. Does the item pass [the gate](#the-gate)? If not, delete the doc comment.
2. Is it within its tier's [budget](#the-budget), and no longer than the doc of the function it serves?
3. Does the first sentence say what the function does, without starting from an argument name?
4. Could a better argument or function name replace a sentence?
5. Does every sentence follow from the one before it, or is it a list?
6. Is there a line that only defines a term? Fold it into the sentence that uses the term.
7. Is there a line that stands alone but is really a consequence of another? Connect them.
8. Does any line state a well-established convention, like "`None` skips an iteration"? Remove it.
9. For every argument mentioned: would a reader who has not seen the body know what it does?
10. Does any line describe how the function works rather than what it does? Remove it.
11. Does a sentence lead with "If `x=...`," or "With `x`," for a non-default case?
    Describe the default or the behaviour first, then the argument that changes it.
12. Does a sentence use "otherwise", or chain several clauses with commas? Split it into direct sentences.

## Spelling

Use British spelling, except for variable names and function names if the rest of the code already uses American spelling.
Always use British English in comments.

## Style

Name things concretely: "counts the amount of entries that do not pass a specific test". "min, max, null count and sizes", not "what it records".
Use "minimum/maximum" and "number of distinct values", not loaded single words.

### Oxford Comma

Use and Oxford comma when making lists
"The sum of a, b, and c."

### describing booleans

When describing a boolean parameter (or const generic), write it with its value:
"`listed=false`", not "if not `listed`".
Where it goes in the sentence is covered in [Behaviour first, then the argument that changes it](#behaviour-first-then-the-argument-that-changes-it).

```rust
/// `parts` only holds a single part per row if `listed=false`.
fn foo(parts: &dyn Array, listed: bool) {}
```

### Prefer short sentences

Don't drag things on with many commas. Keep sentences short, clear, and concise.
If you make two different statements, which would cause the sentence to go on forever,
put them in two separate sentences.
It is fine if this means you have to repeat the (short) subject again.

#### Use :, and ; sparingly

See the rule above: these could most of the time be separate sentences.

#### Don't use complex unicode characters

Don't use `… `, just use `...`
Don't use an em dash, just used `--`

#### Don't repeat information everywhere

If function `foo` has a limitation, that belongs in its doc comment.
You don't have to now repeat that limitation where you call `foo`.

If you need to repeat information, prefer *referencing* other things instead.
When wrapping functions, you may simply use a `see [foo]`.
Prefer referencing to things that are part of the API rather than the other way around.

The same goes for functions that only differ a little bit.
In the doc comment, refer to the other functions, and then describe what this does differently.

If we have a central reference document (e.g. a README),
then that is our source of truth.
If information is already here,
you should **not** repeat it again elsewhere as e.g. a module comment.

If you have moved something to a central place,
it should be clear that that information pertains to this unit.
If only 20% of the functions are affected by it, you should reference explicitly.
If the information in the central place clearly affects (almost) all functionality,
then you don't have to explicitly link it.
Consider it a 'you must know this to read this module at all' in such a case.

### Put descriptions close to the action

If a specific function is implemented in a certain way for e.g. performance reasons,
then that should be written at the function, not at the module doc.

If many functions are implemented in the same way for the same reason though,
the rule to not repeat yourself takes precedence.
In such a case, put it in a central place.

### Use descriptive function names

A function name by itself should be informative enough to get a rough understanding
of what it does. Don't call a function `polygons`, call a function `do_action_for_polygons`.

For functions that return a boolean, name these like `is_polygon_valid` rather than `valid`.

For member functions (methods in rust) you don't have to repeat the object name of course.
`Polygon::has_x` rather than `Polygon::polygon_has_x`

#### Helpers with a single caller

A helper with exactly one caller is named after that caller, and put directly below it.
Use `<caller>_<what>`, e.g. `buffer_into_polygons_reverse_rings`,
or `<caller>_internal` if the helper is the caller's whole body (such as a generic inner function).
The name then says where it belongs, so it does not need a doc comment.
In Rust, do not prefix it with `_` instead: that silences the `dead_code` lint,
so an orphaned helper would go unnoticed.

Once such a helper gets a second caller, give it a name of its own,
and check it against [the gate](#the-gate) again.
