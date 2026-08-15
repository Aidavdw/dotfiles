-- NOTE: For fold methods, I prefer to use treesitter's.
-- See the treesitter config.

vim.o.foldenable = true
-- Start folded at this level.
-- High number = don't start anything folded.
vim.o.foldlevel = 99
-- Show a little column on the left with the nesting level.
-- If you make it wider (>1) then it will be like a contour,
-- which is cute but takes up a lot of space.
-- vim.o.foldcolumn = 1
-- TODO: merge the fold column with indent blankline
-- https://www.reddit.com/r/neovim/comments/1ag3uta/finally_the_combination_of_foldcolumn/

-- Customise how the folds look.
-- https://github.com/neovim/neovim/pull/20750
vim.o.foldtext = ""
vim.o.fillchars = "fold:-"
