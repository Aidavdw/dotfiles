# Global claude.md

Use British spelling.

## Making memories

Always first ask me for confirmation if you want to add a memory.
That way we avoid things being taken out of context.

## Sparring design options

- When comparing design options, state the trade-offs neutrally and verify claims about what each option lacks before recommending one.

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

### Benchmarking

`perf record -g` (call-graph) does not work here. Use `perf stat` or plain `perf record`, and pass `--no-debuginfod` (or set DEBUGINFOD_URLS="") so perf doesn't try to reach the network.

## Reporting style

- Never address or refer to me by name: not in replies, thinking, or memory files. Use "you" in chat and "the user" in memory.

## Comment style

See the comment skill for this (`~/.claude/skills/comments/SKILL.md`)

## Markdown tables

Don't pad everything with spaces in markdown tables.
Just leave one space before and one space between the `|` and the cell content.
