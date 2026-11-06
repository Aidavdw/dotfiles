---
name: snippet
description: "Write the work-update snippet for the last complete check-in interval (Friday 20:00 – Wednesday 20:00, or Wednesday 20:00 – Friday 20:00), from the user's commits."
disable-model-invocation: true
---

Write a short update for the user's boss on what the user got done in the last complete check-in interval.

## Steps

1. Run `~/.claude/skills/snippet/collect.sh`.
   It picks the interval (boundaries are Wednesday and Friday at 20:00, with 4 hours of leeway, so on Wednesday 16:00 it already gives Friday – Wednesday)
   and lists, per repository, every commit authored in it.
   In large shared repositories (like polars) it lists only the user's commits; leave it at that.
2. Read what the commits actually do: `git -C <repo> show --stat <hash>`, and the diff itself for the substantive ones.
   Skip reading formatting, comment and typo commits.
   A subject ending in `(#123)` is a squash-merged PR; the branch commits before it are the same work.
   The same commit can show up under two repositories when one has the other as a remote; count it once, under the project it belongs to.
3. Group the commits into outcomes: everything related goes under one bullet, every unrelated thing gets its own.
   Leave out the dotfiles repository (personal configuration).

## Output

Print the snippet in a fenced `markdown` block so the user can copy it with `/copy`, and nothing else around it:

```markdown
**Fri 30 Oct 20:00 – Wed 4 Nov 20:00**

- <project>: <outcome>, <key decision>. (#123)
- ...
```

- Always start with the exact interval from the script.
- Past tense, about outcomes, never activity: "Added X", "Fixed Y so that Z", never "worked on X" or "made progress on Y".
- Concrete: name the feature, expression, format or bug.
- Very brief: one line per bullet where possible, at most two. Only mention a decision when it is a key one (a trade-off, a limitation chosen, an approach rejected).
- Mention merged PR numbers; say "(open)" for work that has not landed yet when that is clear from the branch.
- Use British spelling.
