vim.g.netrw_banner = 0 -- Hide the banner on top
-- vim.g.netrw_liststyle = 3 -- Tree display style.

-- Open netrw (file browser)
vim.keymap.set("n", "<leader>on", "<cmd>Ex %:h<CR>", { desc = "open netrw (parent of current file)" })
