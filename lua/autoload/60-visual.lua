-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- The Catppuccin plugin for some reason now takes a stupid long time to load, so we'll use a builtin one.
-- If we change it again, you'll probably have to remove this, and set it during lazy load.
-- built-in colour schemes can be found in `/usr/share/nvim/runtime/colors/`.
vim.cmd.colorscheme("catppuccin")
-- We can make the background transparent (terminal colour, so if that is transparent too yalla) using:
-- `vim.cmd.highlight({ "Normal", "guibg=NONE" })`
-- or make it black (high-contrast) using:
-- `vim.cmd.highlight({ "Normal", "guibg=black" })`

-- Always show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
