---
name: bench-compare
description: "Benchmark a change before and after: release builds of both sides, randomised interleaved runs, and a report of the medians ± standard deviation and the change between them. Use whenever performance numbers comparing two commits are needed."
argument-hint: "[target: a commit, a branch, or <a>..<b>] [what to benchmark] (default: the current branch, cases proposed from the diff)"
---

Compare the performance of two commits.
Build both in release mode, prepare the benchmark cases, and stop at the ready banner.
Only after the user says yes, run `bench.py`, which does all timing and statistics, and report its numbers.

`bench.py` and `bench_harness.py` live next to this file, in `~/.claude/skills/bench-compare/`.
Run `bench.py` with `python3`.

## Guardrails

- Every number comes from a release build of both sides. Never build or time a dev build.
- Never start timing before the user has said yes to the ready banner.
  Other projects may be running benchmarks on this machine.
- Every number you report comes from `bench.py run`.
  Never report times from smoke tests, calibration, or anything you timed yourself.
  Never recompute, round differently, or reorder its table.
- While `bench.py run` is going, run nothing else that uses CPU: no builds, tests or searches.

## Sandbox

Everything here runs inside the sandbox.
`~/.cache/bench-compare` is writable, `.git` is not, so the sources come from `git archive`, never from a worktree.
Builds must work offline.
If cargo or maturin needs to download something, stop and ask before running that step unsandboxed.

## Layout

Everything for a repo lives in `~/.cache/bench-compare/<repo>/`, where `<repo>` is the repo directory's name.
Nothing in it is ever deleted: the user cleans it up manually.

```text
<repo>/
  target/        the CARGO_TARGET_DIR shared by both sides
  before/        src/ (the sources), wheels/, site/ (unpacked wheels), bin/
  after/         the same for the after side
  cases/         one script per case
  spec.json      what bench.py runs
```

The shared target dir builds the dependencies once.
Cargo keys workspace crates by their path, so each side keeps its own incremental build.
Its uplifted artefacts (e.g. `target/release/<bin>`) are shared though,
so build the sides one after the other, and copy each side's artefacts out before building the next.

## Steps

1. **Settle the two sides.**
   The argument is one of:

   - `<commit>`: before is `<commit>^`, after is `<commit>`;
   - `<branch>`: before is `git merge-base master <branch>` (or `main`, whichever exists), after is the branch tip;
   - `<a>..<b>`: before is `<a>`, after is `<b>`;
   - nothing: as `<branch>`, for the current branch.

   If the argument could mean several of these (e.g. a branch name that is also a hash prefix), ask.
   Stop and tell the user if `git status --porcelain --untracked-files=no` shows uncommitted changes:
   they are not part of either side, and you must not guess whether they were meant to be.
   Stop if both sides resolve to the same commit.

   Done when both sides are full commit hashes.

2. **Copy the sources.**
   For each side, run `python3 bench.py sync <repo path> <commit> ~/.cache/bench-compare/<repo>/<side>/src`.
   It prints the commit hash, and leaves the modification times of unchanged files alone,
   so the next build is incremental.

3. **Build both sides in release mode, one after the other.**
   Run builds in the background, as a polars build can take a long time.
   Always set `CARGO_TARGET_DIR=~/.cache/bench-compare/<repo>/target`.
   Clear a side's `wheels/` before building it, and replace its `site/` with the unpacked wheels
   (`python3 -m zipfile -e <wheel> <side>/site`).

   **polars** (`<side>` is `~/.cache/bench-compare/polars/<side>`; run from `<side>/src`):

   - Get the flags the Makefile would use:
     `make -s --no-print-directory --eval 'bench-flags: ; @echo "$(RUSTFLAGS)"' bench-flags`,
     and the same with `$(CFLAGS)`.
   - Run `~/polars/.venv/bin/python tools/update-cargo-env.py` with those `RUSTFLAGS` and `CFLAGS` set.
   - Run `~/polars/.venv/bin/maturin build -m py-polars/runtime/polars-runtime-32/Cargo.toml --features backtrace_filter --profile nodebug-release --out <side>/wheels`,
     with the same flags set.
   - The Python package is pure Python and comes straight from `<side>/src/py-polars/src`.
   - Interpreter: `~/polars/.venv/bin/python`.
     Side environment: `PYTHONPATH=<side>/src/py-polars/src:<side>/site` and `POLARS_FORCE_PKG=32`.
     Modules to check: `polars` below `<side>/src/py-polars/src`, and `polars._plr` below `<side>/site`.

   **geopolars** (`<side>` is `~/.cache/bench-compare/geopolars/<side>`):

   - Both sides run against the polars already installed in `~/geopolars/.venv`.
     The polars `rev` in each side's `Cargo.toml` must therefore equal the hash in the name of `~/geopolars/.polars/.rev-<hash>`.
     If any of the three differ, stop and tell the user.
   - Run `~/geopolars/.venv/bin/maturin build --release --out <side>/wheels` from `<side>/src/geopolars`.
   - Interpreter: `~/geopolars/.venv/bin/python`.
     Side environment: `PYTHONPATH=<side>/site`.
     Modules to check: `geopolars` below `<side>/site`.

   **Anything else:** use the project's `release` profile (`cargo build --release`, `maturin build --release`, ...),
   and copy the binaries a case runs into `<side>/bin/` before building the other side.

   Done when both sides are built, and a build failure has been reported and resolved with the user.

4. **Write the cases.**
   If the user did not name what to benchmark, propose cases from the diff:
   the expressions or code paths the change touches, with input that exercises the changed code.

   For polars and geopolars, a case is a Python script in `cases/` that isolates the expression under test:

   ```python
   import numpy as np
   import polars as pl
   from bench_harness import run_case


   def build_query(scale: int) -> pl.LazyFrame:
       values = np.random.default_rng(0).random(scale)
       return pl.DataFrame({"x": values}).lazy().select(pl.col("x").sqrt())


   run_case(build_query)
   ```

   - The plan is `df.lazy().select(<expr>)` and nothing else, unless the expression genuinely needs more.
   - Build the input in memory, inside `build_query`, which is never timed.
     Generate it from a seeded generator such as numpy's, never with polars functions:
     those can differ between the sides, and both sides must get identical input.
   - `scale` sets the input size (usually the number of rows).
     `bench.py` calibrates it on the before side, so that one execution takes 50 to 300 ms.
   - Leave out IO, and helpers that do work while the plan is built, such as `gpl.from_geoparquet`.
   - `run_case` builds the query once, runs it once untimed, then times it `BENCH_RUNS` times (default 1).
     On the streaming engine it times execution only, without planning.
     On the in-memory engine it times the whole `collect`,
     which is why the plan must stay minimal.

   Every case runs on both engines, as two entries in the spec.
   Anything that is not a Python polars query is timed as the wall-clock time of the whole process.

   Smoke-test each case once per side and engine at a scale of at most 10,000,
   with the side's environment plus `BENCH_ENGINE`, `BENCH_SCALE`,
   `BENCH_CHECK_MODULES` and `POLARS_LOG_METRICS=1` for the streaming engine.
   This only checks that the case runs and loads each side's own build: it is not a benchmark, so never report its times.

5. **Write `spec.json`.**

   ```json
   {
     "profile": "nodebug-release",
     "sides": {
       "before": {
         "commit": "<full hash>",
         "env": {"PYTHONPATH": "...", "POLARS_FORCE_PKG": "32"},
         "modules": {"polars": "<prefix>", "polars._plr": "<prefix>"},
         "vars": {"bin": "<before>/bin/tool"}
       },
       "after": {"...": "the same for the after side"}
     },
     "cases": [
       {"name": "sqrt", "engine": "streaming", "scale": 1000000,
        "argv": ["/home/<user>/polars/.venv/bin/python", "<cases>/sqrt.py"]},
       {"name": "sqrt", "engine": "in-memory", "scale": 1000000,
        "argv": ["/home/<user>/polars/.venv/bin/python", "<cases>/sqrt.py"]},
       {"name": "tool --flag", "argv": ["{bin}", "--flag"]}
     ]
   }
   ```

   - A case with an `engine` is timed by `bench_harness`.
     One without is timed as the wall-clock time of the whole process.
   - `{name}` in `argv` is replaced by the side's `vars[name]`, and `{scale}` by the calibrated scale.
   - A case without `scale` is not calibrated.
     Pick its input so it takes at least 50 ms anyway.
   - `bench.py` fails a run if a module in `modules` was loaded from outside its prefix.
   - Use absolute paths everywhere: `~` is not expanded.

6. **Check the machine, and stop at the ready banner.**
   Run `python3 bench.py check`.
   It reports the power state, CPU governor, load and the busiest core, and warns when:

   - the laptop is on battery;
   - the 1-minute load average is above 2.0;
   - one core was more than 50% busy over a second (the sandbox hides other processes, so this stands in for a busy process).

   Then send the user one message with:
   the two commits, the build profile, every case (its expression, input, engines and starting scale),
   every warning from the check in full, and on the last line:

   ```text
   ==== Benchmark is ready! ====
   ```

   Wait for the user's yes.
   If there were warnings, the user may want you to check again first.

7. **Run.**
   Run `python3 bench.py run ~/.cache/bench-compare/<repo>/spec.json` in the background.
   Per case, it:

   - calibrates the scale on the before side, timing one run per process;
   - runs one discarded warm-up per side;
   - runs randomised blocks: each round runs both sides once, in random order, in fresh processes.
     Each of those processes times 10 runs, as building the input usually costs far more than a run;
   - starts with 3 rounds, then adds one at a time until the change is conclusive, up to 6 rounds (30 to 60 runs per side).
     A wall-timed case gets one run per process, so it starts with 5 rounds and adds 5 at a time, up to 50.
     The change is conclusive once its 95% confidence interval lies inside ±5% (no change that matters),
     or excludes 0 (a clear change).
     The interval comes from the ratio of after to before within each round, so drift that hits a whole round cancels out.
     Each side contributes the median of its process's runs, as the runs within one process are not independent samples.

   If it fails, report the error, fix the case or spec, and ask again before rerunning.

8. **Report.**
   Copy the header line, table and notes that `bench.py run` prints, unchanged.
   The table gives median ± standard deviation over all runs of each side, and the change between the medians as (after - before) / before.
   The 95% CI column is the confidence interval of that change, and `n` gives the rounds × runs per process.
   A `~` means the interval contains 0, so no change was detected.
   If a row is marked ⚠, say plainly that it is still inconclusive at its maximum number of rounds:
   it can neither rule out a change of 5% or more, nor show that there is a change at all.
   Add at most a few sentences of interpretation, and keep it apart from the numbers.
