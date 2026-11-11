
## Check if the kernel follows the standard pattern

See `docs/Kernel implementation guide.md` for this.

## Duplication of helpers

Look at the helpers defined in the module.
Does this kernel define any helper functions that already exist as convenience methods
on the view types (e.g. PolygonArray)?
Then it should simply use that function.

Does it have a `pub(super)`,
or `use` one from another module that is not a 'global' convenience method or helper?
Check how 'generic' that function is. If it clearly is a helper that is used directly for the kernel,
then that is fine and can stay there.
If it is something like 'adds 1 to all of the coordinates' in a module for 'getting the distance',
then it should be made a shared helper, even if it has only one user.

See if you can find any expressions in this module and in other modules that do the same thing.
If they are, the should be put in a central location again, per the above.

## Location of helpers

Helpers that simply get something from the views (e.g. 'get the outer ring of the polygons')
should be placed in the geopolars-core crate.
Other examples of such functions would be filters.
A good rule of thumb is this: If it needs to allocate, it probably does not belong here.

Helpers that actually *transform* data should be placed in the geopolars-compute crate.
You may put them in a sub-module at the root of the `geopolars-compute` crate.

## Common arguments

The expressions must use the 'common arguments' if possible,
rather than re-defining new ones in slightly different words.
They are described in `docs/Common arguments.md`.
An argument it lists as *Legacy* should not be used in new code.

### Some arguments imply another argument also being required

Any function that can remove points must also always take the `short_lines` argument,
as dropping parts can make rings and linestrings too short.
This means that any constructor takes the `null_parts` argument must take it too.

Make sure that kernel that takes a polygon (or multipolygon) and the
`short_lines` argument must also take an `empty_polygon_exterior` argument,
as anything that removes points from a ring can otherwise invalidate a polygon.

Any function that takes `new_ring_orientation` must also take `new_holes`,
if it can output a polygon.

Any function taking the `promote_to_multi` argument must also take the `on_row_error` argument,
as with `"never"`, a result with several parts raises an error here.

Any function taking `early_coord_check` also requires `on_row_error` due to handoff.

### `new_ring_orientation` on GEOS kernels

If you are wrapping a GEOS kernel and have a `new_ring_orientation`, fuzz test with Shapely to see if the operation always gives the standard GEOS orientation (per the "GEOS kernel implementation guide").

## Native kernel-specific

These need to be checked for native kernels, not for ones that simply forward to an external tool.

### Compare the numerical implementation to that in GEOS

Try to find if this expression has a GEOS equivalent.
GEOS is a very stable and battle-tested library.
It will probably have a lot of very specific checks for numerical checks and ways of calculating things.
Floats can be very finnicky, so sometimes a 'simple multiplication' cannot be a
'simple multiplication' because of some numerical instabilities or subnormal numbers.
Compare how we do the actual calculation with how it is done in GEOS.
Look at the GEOS source code for this.
If something is much more complicated there, it is probably for a reason.
Try to figure out what that reason is.
Then try to answer the question "Do we adequately guard for it here in our native kernel too?"
