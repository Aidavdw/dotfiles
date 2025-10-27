-- General vim and nvim options.

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Always show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Time before cursorhold is triggered
-- Also inactivity time before swap file is written to
vim.opt.updatetime = 250

-- Time before a key sequence is considered timed out
-- (e.g <super>if, and you wait a bit between i and f)
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
	multispace = "·",
	-- So that space instead of tab for indentation does not mess you up
	leadmultispace = " ",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Vim looks for some keywords to determine if a file is PlainTeX, CoNTeXT, or LaTeX. This setting makes it revert to latex if keywords are not found.
vim.g.tex_flavor = "latex"

----------------------------
-- Wrapping & word breaking
----------------------------
-- wrap around text if it goes off-screen. This breaks off words mid-word.
-- vim.o.wrap = true
-- Wrapping on a word basis, so you don't cutt of words so much.
vim.o.linebreak = true
-- Add character to start of wrapped line.
vim.o.showbreak = " 󱞵 "

-- Wrapped lines are indented.
vim.opt.breakindent = true

-----------------------
-- Spell checking
-----------------------
-- Loading all spell files makes spell checking really slow.
-- TODO: allow toggling languages on and off, as done in
-- linkarzu https://www.youtube.com/watch?v=uLFAMYFmpkE.
-- English_gb should always be loaded. cjk, nl and de toggleable (with english still enabled too).
-- All custom words should just go in a english.
vim.opt.spelllang = { "en_gb", "nl", "de", "cjk" }
vim.opt.spell = true
vim.opt.spelloptions = "camel"
