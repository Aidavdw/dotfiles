#!/usr/bin/env python3
"""
Compare files in a source directory against a (nested) target directory.

Usage:
    python compare_dirs.py <source_dir> <target_dir>

For each file in source_dir, checks whether a file with the same name exists
anywhere in target_dir (including subdirectories), and prints the result.
"""

import argparse
import sys
from pathlib import Path


def build_target_index(target_dir: Path) -> dict[str, list[Path]]:
    """Return a dict mapping filename -> list of relative paths in target."""
    index: dict[str, list[Path]] = {}
    for path in target_dir.rglob("*"):
        if path.is_file():
            index.setdefault(path.name, []).append(path.relative_to(target_dir))
    return index


def compare(source_dir: Path, target_dir: Path) -> None:
    source_files = sorted(p for p in source_dir.rglob("*") if p.is_file())

    if not source_files:
        print("No files found in source directory.")
        return

    target_index = build_target_index(target_dir)

    header = f"{'SOURCE FILE':<60}  {'STATUS':<10}  TARGET FILE(S)"
    print(header)
    print("-" * len(header))

    present = missing = 0

    for src_path in source_files:
        src_rel = src_path.relative_to(source_dir)
        matches = target_index.get(src_path.name, [])

        if matches:
            label = "✔  present"
            target_str = ",  ".join(str(m) for m in matches)
            present += 1
        else:
            label = "✘  missing"
            target_str = "-"
            missing += 1

        print(f"{label:<10} | {str(src_rel):<60} | {target_str}")

    print("-" * len(header))
    print(f"{len(source_files)} source file(s): {present} present, {missing} missing.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Check which source files are present/missing in a target directory tree."
    )
    parser.add_argument("source_dir", help="Directory whose files you want to look up")
    parser.add_argument("target_dir", help="Directory tree to search in")
    args = parser.parse_args()

    source_dir = Path(args.source_dir).resolve()
    target_dir = Path(args.target_dir).resolve()

    for label, path in [("Source", source_dir), ("Target", target_dir)]:
        if not path.exists():
            print(f"Error: {label} directory does not exist: {path}", file=sys.stderr)
            sys.exit(1)
        if not path.is_dir():
            print(f"Error: {label} path is not a directory: {path}", file=sys.stderr)
            sys.exit(1)

    compare(source_dir, target_dir)


if __name__ == "__main__":
    main()
