# Global claude.md

Use British spelling.

## Helper functions

Using short helper functions is great if that makes the code more legible,
and stops you from repeating the same code a lot.
With these functions, keep the name descriptive.
If you do this, almost always, this means they do *not* need a doc comment.

## Line breaking

If you need to line-break a long sentence, prefer doing it directly after punctuation,
or otherwise directly before brackets etc. for both for prose, and for comments.

```text
Imagine this was a long line,
then this would be my preferred way
(even if it sometimes makes one line much longer than the other),
always. It does not mean you always must start on a new line though.
```

## Sandbox

You run in a sandbox.
Some commands need to run outside of it, so you have to ask me for permission:

- `gh --json`.
- `uv`, when it needs to connect to the internet.

## Reporting style

- Never address or refer to me by name: not in replies, thinking, or memory files. Use "you" in chat and "the user" in memory.

## Comment style

Name things concretely: "min, max, null count and sizes", not "what it records".
Use "minimum/maximum" and "number of distinct values", not loaded single words.

In function docs, give each parameter its own clause instead of chaining "the X of Y of Z".

### describing booleans

When describing a boolean parameter (or generic), prefer writing it with a value.

```rust
/// ...
/// If `X=true`, ...
/// If `y=true`, ...
pub fn foo<const X: bool>(y: bool) {}
```

### Functions that return bools

### Prefer short sentences

Don't drag things on with many commas. Keep sentences short, clear, and concise.
If you make two different statements, which would cause the sentence to go on forever,
put them in two separate sentences.
It is fine if this means you have to repeat the (short) subject again.

#### Use :, ;, and em dashes sparingly

See the rule above: these could most of the time be separate sentences.

#### Don't repeat information everywhere

If function `foo` has a limitation, that belongs in its doc comment.
You don't have to now repeat that limitation where you call `foo`.

If you need to repeat information, prefer *referencing* other things instead.
When wrapping functions, you may simply use a `see [foo]`.
Prefer referencing to things that are part of the API rather than the other way around.

The same goes for functions that only differ a little bit.
In the doc comment, refer to the other functions, and then describe what this does differently.

If something is part of the public API, you may give a short description,
and a reference to the place where this this described more in detail.

If we have a central reference document (e.g. a README),
then that is our source of truth.
If information is already here,
you should **not** repeat it again elsewhere as e.g. a module comment.

### Use descriptive function names

A function name by itself should be informative enough to get a rough understanding
of what it does. Don't call a function `polygons`, call a function `do_action_for_polygons`.

For functions that return a boolean, name these like `is_polygon_valid` rather than `valid`.

For member functions (methods in rust) you don't have to repeat the object name of course.
`Polygon::has_x` rather than `Polygon::polygon_has_x`

#### Don't make useless doc comments

If your function is name `do_action_for_polygons`,
a doc comment like `/// Performs an action [Action] for every polygon`
does not add any information.
In such a case, just leave the function without doc comment.

## Markdown tables

Don't pad everything with spaces in markdown tables.
Just leave one space before and one space between the `|` and the cell content.
