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

You may always ignore any untracked dotfiles such as `.bashrc`, `.gitconfig`, `.idea` and `.claude/agents`.
They are part of the sandbox, and automatically go away when you finish

## Github

If you want to view an issue on github, use it `gh issue view <...> --json`, as you do not get my access token.

### Benchmarking

`perf record -g` (call-graph) does not work here. Use `perf stat` or plain `perf record`, and pass `--no-debuginfod` (or set DEBUGINFOD_URLS="") so perf doesn't try to reach the network.

## Reporting style

- Never address or refer to me by name: not in replies, thinking, or memory files. Use "you" in chat and "the user" in memory.

## Comment style

See the comment skill for this (`~/.claude/skills/comments/SKILL.md`)

## Markdown tables

Don't pad everything with spaces in markdown tables.
Just leave one space before and one space between the `|` and the cell content.

## Benchmarking

Before running a benchmark, always check if the CPU is not yet already being heavily used.
I work on multiple projects at the same time, so I might be running benchmarks or doing something memory-intensive on the side.
If it is busy, wait with the benchmark. If you can do some other things in the meantime, do those first.
If the benchmark is on the critical path, you should wait instead.

No need to use `ps`.
You can check current total resource use from `/proc/stat`,`/proc/loadavg`, and ram usage from `/proc/meminfo`.

Any performance numbers you give me *must* come from a release build.
Never give me numbers from a dev build.
