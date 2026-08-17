-- For LSP keybinds, see lsp.lua
-- For oplugin-specific keybinds, see that plugin's file.

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Goto the next diagnostic, and open its popup.
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" })
-- Potato, but back.
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to previous diagnostic" })

-- Switch windows quickly
vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>w", { noremap = true, silent = true, desc = "Switch active split" })

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
end, { desc = "Toggle word [W]rap" })

-- Open netrw (file browser)
vim.keymap.set("n", "<leader>on", "<cmd>Ex<CR>", { desc = "open netrw (file browser)" })

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

-- `J` joins two lines.
-- For some reason, there is no default keybind to do the opposite-- split two lines.
-- So, we'll make a keybind `Q` for it (next to J on my keyboard layout)
vim.keymap.set(
    "n",
    "Q",
    "i<CR><ESC>k:s/\\s\\+$//e<CR>j<ESC>",
    { desc = "Split line and remove trailing whitespace on the previous line" }
)
