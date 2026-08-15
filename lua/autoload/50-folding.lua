-- Fold methods are defined per-filetype, so see ftplugin for that.\
-- Generally I prefer to use the Treesitter functions for it.
-- Can use the same snippet for it everywhere.
-- Set this per ftplugin
-- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.wo[0][0].foldmethod = 'expr'
-- https://github.com/nvim-treesitter/nvim-treesitter#folds

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

-- TODO: Incremental selection with treesitter
-- with treesitter.nvim I had this:
-- allows you to select around the cursor and dynamically grow it.
-- incremental_selection = {
--     enable = true,
--     keymaps = {
--         init_selection = "<Enter>", -- set to `false` to disable one of the mappings
--         node_incremental = "<Enter>",
--         scope_incremental = "<S-Enter>",
--         node_decremental = "<Backspace>",
--     },
-- },
