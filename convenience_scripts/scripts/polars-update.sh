#!/usr/bin/env bash
# Bring a stale Polars development setup up to date.
# See https://docs.pola.rs/development/contributing/ for the individual steps.
#
# Usage: polars-update.sh [POLARS_REPO], where POLARS_REPO defaults to ~/polars.
#
# This does not touch your checked-out branch or working tree.
# It only fetches upstream, so merging or rebasing is still up to you.
set -euo pipefail

# Run from the Polars repo, so that cargo picks up its pinned nightly from rust-toolchain.toml.
cd "${1:-$HOME/polars}"
if [[ ! -f rust-toolchain.toml ]]; then
    echo "$(pwd) has no rust-toolchain.toml; is this the Polars repo?" >&2
    exit 1
fi

UPSTREAM_URL="https://github.com/pola-rs/polars.git"
COMPONENTS="miri,rust-analyzer,rust-src,clippy,rustfmt"

step() {
    printf '\n\033[1;36m==> %s\033[0m\n' "$*"
}

step "Fetching upstream"
if ! git remote get-url upstream >/dev/null 2>&1; then
    git remote add upstream "$UPSTREAM_URL"
fi
git fetch upstream --prune

# Fast-forward local main, unless it is checked out (then `git pull` it yourself).
if [[ "$(git branch --show-current)" != "main" ]]; then
    git fetch upstream main:main || echo "Local main has diverged from upstream/main; not updating it."
fi

step "Updating the latest nightly toolchain"
rustup toolchain install nightly --component "$COMPONENTS"

# The repo pins a specific nightly in rust-toolchain.toml, which is what cargo actually uses here.
# Install both the one in the working tree and the one on upstream/main.
pinned_channels=$(
    {
        cat rust-toolchain.toml
        git show upstream/main:rust-toolchain.toml 2>/dev/null || true
    } | sed -n 's/^channel *= *"\(.*\)"/\1/p' | sort -u
)
for channel in $pinned_channels; do
    step "Installing pinned toolchain $channel"
    rustup toolchain install "$channel" --component "$COMPONENTS"
done

step "Setting up miri"
cargo miri setup

step "Cleaning build artifacts and the virtual environment"
# This also runs `cargo clean` and removes .venv.
make clean

step "Pruning the uv cache"
if command -v uv >/dev/null 2>&1; then
    uv self update || echo "uv self update failed (perhaps managed by your package manager); continuing."
    uv cache prune
else
    echo "uv not found on PATH; skipping."
fi

step "Recreating the virtual environment and installing requirements"
make requirements

step "Done"
echo "Run 'make build' to compile Polars into the fresh .venv."
