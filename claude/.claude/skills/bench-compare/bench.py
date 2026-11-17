#!/usr/bin/env python3
"""Before-and-after benchmarks for the bench-compare skill, see SKILL.md.

bench.py sync <repo> <ref> <dest>
bench.py check
bench.py run <spec.json>
"""

import argparse
import json
import math
import os
import random
import statistics
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from typing import NamedTuple

SKILL_DIR = Path(__file__).resolve().parent
SIDES = ("before", "after")


class RoundLimits(NamedTuple):
    minimum: int
    added_at_a_time: int
    maximum: int


# Building the input usually costs far more than a run, so each process times several runs.
RUNS_PER_PROCESS = 10
PRINTED_ROUND_LIMITS = RoundLimits(minimum=3, added_at_a_time=1, maximum=6)
# A wall-timed case gets a single run per process, so it needs more rounds.
WALL_ROUND_LIMITS = RoundLimits(minimum=5, added_at_a_time=5, maximum=50)
# A smaller change does not matter, so a confidence interval inside ±RELEVANT_CHANGE is conclusive.
RELEVANT_CHANGE = 0.05
# Exact, where the Cornish-Fisher expansion in `t_quantile_975` is too far off.
T_QUANTILE_975_FOR_FEW_DEGREES = {1: 12.706, 2: 4.303, 3: 3.182, 4: 2.776, 5: 2.571}

MIN_SECONDS = 0.05
MAX_SECONDS = 0.3
TARGET_SECONDS = 0.12
MAX_CALIBRATION_STEPS = 10

MAX_LOAD = 2.0
MAX_CORE_BUSY = 0.5


class BenchError(Exception):
    pass


def log(message: str) -> None:
    print(message, file=sys.stderr, flush=True)


# sync


def sync_source(repo: str, ref: str, dest: str) -> None:
    """Makes `dest` hold exactly the tree of `ref`, and prints the full commit hash.

    Only files whose contents changed get a new modification time,
    so an incremental cargo build in `dest` rebuilds exactly what changed.
    """
    commit = git_output(repo, "rev-parse", "--verify", f"{ref}^{{commit}}")
    Path(dest).mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as extracted:
        archive = subprocess.Popen(
            ["git", "-C", repo, "archive", commit], stdout=subprocess.PIPE
        )
        subprocess.run(["tar", "-x", "-C", extracted], stdin=archive.stdout, check=True)
        archive.stdout.close()
        if archive.wait() != 0:
            raise BenchError(f"git archive {commit} failed")
        # Extracting into `dest` directly would date every file at the commit time,
        # which can be older than the last build, so cargo would skip changed files.
        # Without `-t`, rsync instead dates each file it copies now.
        subprocess.run(
            ["rsync", "-rlp", "--checksum", "--delete", f"{extracted}/", f"{dest}/"],
            check=True,
        )
    print(commit)


def git_output(repo: str, *args: str) -> str:
    result = subprocess.run(["git", "-C", repo, *args], capture_output=True, text=True)
    if result.returncode != 0:
        raise BenchError(result.stderr.strip())
    return result.stdout.strip()


# check


def read_text(path: Path) -> str | None:
    try:
        return path.read_text().strip()
    except OSError:
        return None


def power_state() -> str:
    supplies = Path("/sys/class/power_supply").glob("*")
    mains = [supply for supply in supplies if read_text(supply / "type") == "Mains"]
    if not mains:
        return "unknown"
    if any(read_text(supply / "online") == "1" for supply in mains):
        return "plugged in"
    return "on battery"


def busiest_core_fraction(interval: float = 1.0) -> float:
    """Measures how busy the busiest core is over `interval` seconds.

    The sandbox hides other processes,
    so this stands in for spotting one process that keeps a core busy.
    """
    before = core_ticks()
    time.sleep(interval)
    after = core_ticks()
    fractions = [0.0]
    for core, (total, idle) in after.items():
        total_delta = total - before[core][0]
        idle_delta = idle - before[core][1]
        if total_delta > 0:
            fractions.append(1 - idle_delta / total_delta)
    return max(fractions)


def core_ticks() -> dict[str, tuple[int, int]]:
    """The total and idle ticks per core, from `/proc/stat`."""
    ticks = {}
    for line in Path("/proc/stat").read_text().splitlines():
        name, *fields = line.split()
        if name.startswith("cpu") and name != "cpu":
            # user, nice, system, idle, iowait, irq, softirq and steal. Guest time is already in user.
            counts = [int(field) for field in fields[:8]]
            ticks[name] = (sum(counts), counts[3] + counts[4])
    return ticks


def system_state() -> dict:
    governor = read_text(Path("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"))
    return {
        "power": power_state(),
        "governor": governor or "unknown",
        "load": os.getloadavg()[0],
        "busiest_core": busiest_core_fraction(),
    }


def system_warnings(state: dict) -> list[str]:
    warnings = []
    if state["power"] == "on battery":
        warnings.append("The laptop is on battery power. Plug it in.")
    if state["load"] > MAX_LOAD:
        warnings.append(
            f"The 1-minute load average is {state['load']:.2f}, above {MAX_LOAD}."
        )
    if state["busiest_core"] > MAX_CORE_BUSY:
        warnings.append(
            f"A core was {state['busiest_core']:.0%} busy over 1 s, so something else is running."
        )
    return warnings


def check() -> None:
    state = system_state()
    print(f"power: {state['power']}")
    print(f"governor: {state['governor']}")
    print(f"load (1 min): {state['load']:.2f}")
    print(f"busiest core: {state['busiest_core']:.0%}")
    for warning in system_warnings(state):
        print(f"WARNING: {warning}")


# run


def run(spec_path: str) -> None:
    spec = json.loads(Path(spec_path).read_text())
    validate_spec(spec)
    seed = spec.get("seed", random.randrange(2**32))
    rng = random.Random(seed)

    state = system_state()
    warnings = system_warnings(state)
    for warning in warnings:
        log(f"WARNING: {warning}")

    results = [bench_case(spec, case, rng) for case in spec["cases"]]
    results_path = Path(spec_path).with_suffix(".results.json")
    results_path.write_text(
        json.dumps(
            {"spec": spec, "seed": seed, "state": state, "results": results}, indent=1
        )
    )
    print(report(spec, seed, state, warnings, results, results_path))


def validate_spec(spec: dict) -> None:
    for side in SIDES:
        if "commit" not in spec.get("sides", {}).get(side, {}):
            raise BenchError(f"the spec needs sides.{side}.commit")
    for case in spec.get("cases") or []:
        if "name" not in case or "argv" not in case:
            raise BenchError(f"every case needs a name and argv: {case}")
        if case_timing(case) == "printed" and "engine" not in case:
            raise BenchError(f"{case['name']}: printed timing needs an engine")
    if not spec.get("cases"):
        raise BenchError("the spec has no cases")


def case_timing(case: dict) -> str:
    return case.get("timing") or ("printed" if "engine" in case else "wall")


def bench_case(spec: dict, case: dict, rng: random.Random) -> dict:
    """Times `case` on both sides in randomised blocks, until the change is conclusive.

    Each block runs both sides once, in random order, so slow drift hits both sides alike.
    """
    log(f"== {case_label(case)}")
    scale = calibrate_scale(spec, case)
    wall_timed = case_timing(case) == "wall"
    runs = 1 if wall_timed else RUNS_PER_PROCESS
    limits = WALL_ROUND_LIMITS if wall_timed else PRINTED_ROUND_LIMITS
    # The times of each process, per side.
    times = {side: [] for side in SIDES}

    for side in rng.sample(SIDES, 2):
        run_once(spec, case, side, scale, runs=1)

    def run_rounds(count: int) -> None:
        for _ in range(count):
            for side in rng.sample(SIDES, 2):
                times[side].append(run_once(spec, case, side, scale, runs))
        log(
            f"   {len(times['before'])} rounds of {runs} runs,"
            f" 95% CI of the change {format_interval(change_interval(times))}"
        )

    run_rounds(limits.minimum)
    while (
        not is_conclusive(change_interval(times))
        and len(times["before"]) < limits.maximum
    ):
        run_rounds(min(limits.added_at_a_time, limits.maximum - len(times["before"])))

    return {
        "name": case["name"],
        "engine": case.get("engine"),
        "scale": scale,
        "times": times,
    }


def calibrate_scale(spec: dict, case: dict) -> int | None:
    """Finds a scale at which one run on the before side takes `MIN_SECONDS` to `MAX_SECONDS`.

    Returns `None` for a case without a scale, which then runs as it is.
    """
    scale = case.get("scale")
    if scale is None:
        return None

    # The first run after a build pays for cold caches.
    run_once(spec, case, "before", scale, runs=1)
    [seconds] = run_once(spec, case, "before", scale, runs=1)
    for _ in range(MAX_CALIBRATION_STEPS):
        if MIN_SECONDS <= seconds <= MAX_SECONDS:
            log(f"   scale {scale:,}: {seconds:.3g} s")
            return scale
        factor = min(max(TARGET_SECONDS / seconds, 0.1), 10.0)
        new_scale = max(1, round(scale * factor))
        if new_scale == scale:
            break
        [new_seconds] = run_once(spec, case, "before", new_scale, runs=1)
        # Stops before scaling up without end when a fixed cost dominates.
        if factor >= 3 and new_seconds < seconds * factor / 3:
            raise BenchError(
                f"{case['name']}: the time barely grows with the scale"
                f" ({scale:,} took {seconds:.3g} s, {new_scale:,} took {new_seconds:.3g} s)"
            )
        scale, seconds = new_scale, new_seconds
    raise BenchError(
        f"{case['name']}: no scale takes {MIN_SECONDS}-{MAX_SECONDS} s"
        f" (scale {scale:,} took {seconds:.3g} s)"
    )


def run_once(
    spec: dict, case: dict, side: str, scale: int | None, runs: int
) -> list[float]:
    """Times `runs` runs of `case` in one process, or the whole process if it is wall-timed."""
    side_spec = spec["sides"][side]
    variables = {**side_spec.get("vars", {})}
    if scale is not None:
        variables["scale"] = str(scale)
    argv = [substitute(arg, variables) for arg in case["argv"]]

    env = {**os.environ, **side_spec.get("env", {}), **case.get("env", {})}
    env["PYTHONPATH"] = os.pathsep.join(
        filter(None, [env.get("PYTHONPATH"), str(SKILL_DIR)])
    )
    if scale is not None:
        env["BENCH_SCALE"] = str(scale)
    env["BENCH_RUNS"] = str(runs)
    if engine := case.get("engine"):
        env["BENCH_ENGINE"] = engine
    if case.get("engine") == "streaming":
        env["POLARS_LOG_METRICS"] = "1"
    modules = side_spec.get("modules", {})
    env["BENCH_CHECK_MODULES"] = ",".join(modules)

    start = time.perf_counter()
    result = subprocess.run(argv, env=env, capture_output=True, text=True)
    wall_seconds = time.perf_counter() - start
    if result.returncode != 0:
        raise BenchError(
            f"{case['name']} ({side}) exited with {result.returncode}:\n{result.stderr[-4000:]}"
        )
    if case_timing(case) == "wall":
        return [wall_seconds]

    check_loaded_modules(result.stdout, modules, f"{case['name']} ({side})")
    printed = [
        line for line in result.stdout.splitlines() if line.startswith("BENCH_SECONDS=")
    ]
    if len(printed) != runs:
        raise BenchError(
            f"{case['name']} ({side}) printed {len(printed)} BENCH_SECONDS lines, not {runs}"
        )
    return [float(line.removeprefix("BENCH_SECONDS=")) for line in printed]


def substitute(arg: str, variables: dict[str, str]) -> str:
    for name, value in variables.items():
        arg = arg.replace(f"{{{name}}}", value)
    return arg


def check_loaded_modules(
    stdout: str, expected_prefixes: dict[str, str], label: str
) -> None:
    """Fails unless every module was loaded from below the directory its side expects."""
    loaded = {}
    for line in stdout.splitlines():
        if line.startswith("BENCH_MODULE "):
            _, name, path = line.split(" ", 2)
            loaded[name] = path
    for name, prefix in expected_prefixes.items():
        path = loaded.get(name)
        if path is None:
            raise BenchError(
                f"{label}: the harness did not report where {name} came from"
            )
        if not path.startswith(os.path.realpath(prefix) + os.sep):
            raise BenchError(
                f"{label}: {name} was loaded from {path}, not from below {prefix}"
            )


def change_interval(times: dict[str, list[list[float]]]) -> tuple[float, float]:
    """The 95% confidence interval of the relative change from before to after.

    It comes from the ratio of after to before within each round,
    so drift that slows down a whole round cancels out.
    Each side contributes the median of its process's runs,
    as runs within one process are not independent samples.
    """
    log_ratios = [
        math.log(statistics.median(after) / statistics.median(before))
        for before, after in zip(times["before"], times["after"])
    ]
    mean = statistics.fmean(log_ratios)
    standard_error = statistics.stdev(log_ratios) / math.sqrt(len(log_ratios))
    margin = t_quantile_975(len(log_ratios) - 1) * standard_error
    return math.expm1(mean - margin), math.expm1(mean + margin)


def t_quantile_975(degrees_of_freedom: int) -> float:
    """The 97.5% quantile of Student's t-distribution.

    From 6 degrees of freedom on, the Cornish-Fisher expansion used here
    is within 0.1% of the exact value.
    """
    if degrees_of_freedom in T_QUANTILE_975_FOR_FEW_DEGREES:
        return T_QUANTILE_975_FOR_FEW_DEGREES[degrees_of_freedom]
    z = statistics.NormalDist().inv_cdf(0.975)
    df = degrees_of_freedom
    return (
        z
        + (z**3 + z) / (4 * df)
        + (5 * z**5 + 16 * z**3 + 3 * z) / (96 * df**2)
        + (3 * z**7 + 19 * z**5 + 17 * z**3 - 15 * z) / (384 * df**3)
    )


def is_conclusive(interval: tuple[float, float]) -> bool:
    """Whether the interval shows either no relevant change, or a clear one."""
    low, high = interval
    return -RELEVANT_CHANGE < low and high < RELEVANT_CHANGE or low > 0 or high < 0


def format_interval(interval: tuple[float, float]) -> str:
    low, high = interval
    return f"[{low:+.1%}, {high:+.1%}]"


# report


def report(
    spec: dict,
    seed: int,
    state: dict,
    warnings: list[str],
    results: list[dict],
    results_path: Path,
) -> str:
    before = spec["sides"]["before"]["commit"]
    after = spec["sides"]["after"]["commit"]
    lines = [
        f"before `{before[:10]}` → after `{after[:10]}`"
        f" · profile `{spec.get('profile', 'unknown')}`"
        f" · power: {state['power']} · governor: {state['governor']}"
        f" · load: {state['load']:.2f} · seed {seed}",
        "",
        "| Case | Engine | Before | After | Change | 95% CI | n |",
        "|---|---|---|---|---|---|---|",
    ]
    inconclusive = []
    for result in results:
        processes = result["times"]["before"]
        rounds = f"{len(processes)}×{len(processes[0])}"
        times_before = [run for process in processes for run in process]
        times_after = [run for process in result["times"]["after"] for run in process]
        median_before = statistics.median(times_before)
        median_after = statistics.median(times_after)
        stdev_before = statistics.stdev(times_before)
        stdev_after = statistics.stdev(times_after)
        interval = change_interval(result["times"])

        if interval[0] <= 0 <= interval[1]:
            change = "~"
        else:
            change = f"{(median_after - median_before) / median_before:+.1%}"
        label = case_label(result)
        if not is_conclusive(interval):
            inconclusive.append(f"{label} after {len(processes)} rounds")
            label = f"⚠ {label}"
        lines.append(
            f"| {label} | {result['engine'] or '-'}"
            f" | {format_duration(median_before, stdev_before)}"
            f" | {format_duration(median_after, stdev_after)}"
            f" | {change} | {format_interval(interval)} | {rounds} |"
        )

    lines.append("")
    if inconclusive:
        lines.append(
            "⚠ Still inconclusive at the maximum number of rounds"
            f" (the 95% CI neither lies inside ±{RELEVANT_CHANGE:.0%} nor excludes 0):"
            f" {'; '.join(inconclusive)}."
        )
    for warning in warnings:
        lines.append(f"Warning at the start: {warning}")
    lines.append(f"Raw times: `{results_path}`")
    return "\n".join(lines)


def case_label(case: dict) -> str:
    if case.get("scale") is None:
        return case["name"]
    return f"{case['name']} (scale {case['scale']:,})"


def format_duration(median: float, stdev: float) -> str:
    for unit, size in (("s", 1.0), ("ms", 1e-3), ("µs", 1e-6), ("ns", 1e-9)):
        if median >= size:
            break
    return f"{format_significant(median / size)} {unit} ± {format_significant(stdev / size)}"


def format_significant(value: float) -> str:
    if value >= 100:
        return f"{value:.0f}"
    if value >= 10:
        return f"{value:.1f}"
    return f"{value:.2f}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    commands = parser.add_subparsers(dest="command", required=True)
    sync_parser = commands.add_parser(
        "sync", help="copy the tree at a ref into a directory"
    )
    sync_parser.add_argument("repo")
    sync_parser.add_argument("ref")
    sync_parser.add_argument("dest")
    commands.add_parser("check", help="report power, CPU governor and load")
    run_parser = commands.add_parser("run", help="run the benchmarks in a spec")
    run_parser.add_argument("spec")
    args = parser.parse_args()

    try:
        if args.command == "sync":
            sync_source(args.repo, args.ref, args.dest)
        elif args.command == "check":
            check()
        else:
            run(args.spec)
    except BenchError as error:
        log(f"error: {error}")
        sys.exit(1)


if __name__ == "__main__":
    main()
