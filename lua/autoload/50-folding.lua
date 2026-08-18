-- NOTE: For fold methods, I prefer to use treesitter's.
-- See the treesitter config.

vim.o.foldenable = true
vim.o.foldlevel = 99
-- Start folded at this level.
-- High number = don't start anything folded.
vim.opt.foldlevelstart = 2
-- If something is folded, everything inside of it might get folded too.
-- This limits how deep that is, so you don't end up unfolding everything 100 times.
vim.opt.foldnestmax = 4
-- Show a little column on the left with the nesting level.
-- If you make it wider (>1) then it will be like a contour,
-- which is cute but takes up a lot of space.
-- vim.o.foldcolumn = 1
-- TODO: merge the fold column with indent blankline
-- https://www.reddit.com/r/neovim/comments/1ag3uta/finally_the_combination_of_foldcolumn/

-- If this is empty, then it will still be syntax highlighted
vim.o.foldtext = ""
-- The characters used to denote a fold are defined in the 'visuals' file.
-- (Because it is a comma-separated string)
