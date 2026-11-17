"""Timing harness for bench-compare case scripts.

A case script builds its query untimed and hands it to `run_case`,
which prints the execution times for `bench.py` to collect.
"""

import importlib
import os
import re
import sys
import tempfile
import time
from collections.abc import Callable
from typing import Any

_METRICS_LINE = re.compile(r"Streaming query took ([\d.]+)(ns|µs|us|ms|s)\b")
_UNIT_SECONDS = {"ns": 1e-9, "µs": 1e-6, "us": 1e-6, "ms": 1e-3, "s": 1.0}


def run_case(build_query: Callable[[int], Any]) -> None:
    """Times `BENCH_RUNS` executions of the LazyFrame that `build_query(scale)` returns.

    Building the input and the query is not timed, and happens once for all runs.
    The query runs once untimed first, to start the thread pool and any lazy initialisation.
    """
    engine = os.environ["BENCH_ENGINE"]
    scale = int(os.environ.get("BENCH_SCALE", "1"))
    runs = int(os.environ.get("BENCH_RUNS", "1"))
    lf = build_query(scale)
    print_loaded_modules()

    lf.collect(engine=engine)
    for _ in range(runs):
        if engine == "streaming":
            seconds = time_streaming_execution(lambda: lf.collect(engine="streaming"))
        else:
            start = time.perf_counter()
            lf.collect(engine=engine)
            seconds = time.perf_counter() - start
        print(f"BENCH_SECONDS={seconds!r}", flush=True)


def print_loaded_modules() -> None:
    for name in filter(None, os.environ.get("BENCH_CHECK_MODULES", "").split(",")):
        module = importlib.import_module(name)
        print(f"BENCH_MODULE {name} {os.path.realpath(module.__file__)}", flush=True)


def time_streaming_execution(collect: Callable[[], Any]) -> float:
    """Runs `collect` and returns the execution time that polars logs for it.

    This excludes planning, unlike timing the call itself.
    Needs `POLARS_LOG_METRICS=1`.
    """
    if os.environ.get("POLARS_LOG_METRICS") != "1":
        raise RuntimeError("streaming timing needs POLARS_LOG_METRICS=1")

    # Polars logs from Rust straight to fd 2, so redirecting `sys.stderr` would not catch it.
    sys.stderr.flush()
    with tempfile.TemporaryFile(mode="w+b") as captured:
        saved_stderr = os.dup(2)
        os.dup2(captured.fileno(), 2)
        try:
            collect()
        finally:
            os.dup2(saved_stderr, 2)
            os.close(saved_stderr)
        captured.seek(0)
        log = captured.read().decode("utf-8", "replace")
    sys.stderr.write(log)

    # A nested query logs its own line before the outer query does.
    matches = _METRICS_LINE.findall(log)
    if not matches:
        raise RuntimeError("polars logged no 'Streaming query took' line")
    value, unit = matches[-1]
    return float(value) * _UNIT_SECONDS[unit]
