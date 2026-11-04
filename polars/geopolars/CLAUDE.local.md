# Personal CLAUDE.md for Geopolars

## Performance

This is a performance-sensitive codebase. After refactoring any validity/repair kernel or shared constructor, run the relevant benchmarks before and after, and report the % change per case (clean vs dirty/NaN data, in-memory vs streaming). Treat any regression over ~5% as something to fix or explicitly flag.

## API conventions

We try to make an API that matches that of Polars itself.

- Prefer Polars-style string mode parameters (e.g. `mode="half_to_even"`, `too_short="null"`) over boolean flags.
- Validity-masked values are called 'null' (not 'missing' or 'invalid').
- Wrapper types must not leak their inner type through any accessor.
- Shared doc sentences go in _docs.py snippets via the @doc decorator.
- Every new expression needs a Rust kernel, plugin layer, Python API and namespace method.

## Tests
Prefer testing from the python side where possible. Only add Rust tests where you cannot test it from the python side.

## Kernel implementation guidelines
You will find these in the docs folder. Follow them closely.
