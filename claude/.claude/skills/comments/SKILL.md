---
name: comments
description: Rules for writing code comments and doc comments, and for naming functions. Use whenever you write, edit or review a comment, doc comment or module doc, or name a function. The core question is whether a comment conveys something the code cannot.
---

Only add comments that actually add something.

## The Golden Rule

The golden rule to ask yourself is: "Does the comment convey something the code cannot?"
Everything else should follow from this.

The answer is **yes** to cases where a comment is needed.

- a non-obvious mechanism, invariant or choice with no *why*;
- a name that says something other than what the thing does.

## Spelling

Use British spelling, except for variable names and function names if the rest of the code already uses American spelling.
Always use British English in comments.

## Style

Name things concretely: "counts the amount of entries that do not pass a specific test". "min, max, null count and sizes", not "what it records".
Use "minimum/maximum" and "number of distinct values", not loaded single words.

In function docs, give each parameter its own clause instead of chaining "the X of Y of Z".
Try to not have sentences that are 80% variable names like "`arg1`, where `value_1` is lower than `value_2`". Instead, try to group them together. "Filters `arg1` that have a property `value_1 < value_2`".

### Oxford Comma

Use and Oxford comma when making lists
"The sum of a, b, and c."

### describing booleans

When describing a boolean parameter (or generic), prefer writing it with a value.

```rust
/// ...
/// If `X=true`, ...
/// If `y=true`, ...
pub fn foo<const X: bool>(y: bool) {}
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

If something is part of the public API, you may give a short description,
and a reference to the place where this is described more in detail.

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

### Implementation details should not leak

A public doc-comment should not say anything about how something works internally.
Anything that is public is part of the user contract, which means they need to know about it.
But if a struct holds a specific internal value, the user does not need to know.

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

#### Don't make useless doc comments

If your function is named something like `do_action_for_polygons`,
a doc comment like `/// Performs an action [Action] for every polygon`
does not add any information.
In such a case, just leave the function without doc comment.

### Keep comments on internal types shorter

An extension on the 'keep it brief' rule. If you have an internal-only struct, this does not need nearly as much nicely written prose as the public facing code.
If a struct value is clear from the name alone, it does not need a comment.
