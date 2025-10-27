-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit insert mode for graphite bros
vim.keymap.set("i", "hs", "<Esc>")

-- Goto the next diagnostic, and open its popup.
vim.keymap.set("n", "gz", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })
-- Potato, but back.
vim.keymap.set("n", "gZ", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to previous diagnostic" })

-- Switch windows quickly
vim.api.nvim_set_keymap("n", "<leader>n", "<C-w>w", { noremap = true, silent = true, desc = "Switch active split" })

-- Search through all todos, as marked with 'TODO_:', 'WARN_:' etc
vim.keymap.set("n", "<leader>wq", "<cmd>TodoTelescope keywords=TODO,FIX,PERF", { desc = "[F]ind open [T]odos" })

-- manually toggle the line wrap. Useful when stuff breaks because of line wrapping or lack thereof. Looking at you, markview.
local line_wrap = true
vim.keymap.set("n", "<leader>vw", function()
	if line_wrap then
		vim.o.wrap = false
		line_wrap = false
	else
		vim.o.wrap = true
		line_wrap = true
	end
end, { desc = "toggle [V]iew: Word [W]rap" })

-- Open netrw (file browser)
vim.keymap.set("n", "<leader>on", ":Ex<CR>", { desc = "[O]pen [N]etrw (file browser)" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- vimdiff commands
vim.keymap.set("n", "<leader>gp", ":diffput<CR>", { desc = "(diff) apply left (first) side" })
vim.keymap.set("n", "<leader>gg", ":diffget<CR>", { desc = "(diff) apply right (second) side" })

-- vim: ts=2 sts=2 sw=2 et
