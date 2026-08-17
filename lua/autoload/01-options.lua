-- General vim and nvim options.

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Time before a key sequence is considered timed out
-- (e.g <super>if, and you wait a bit between i and f)
vim.opt.timeoutlen = 280

-- Time before cursorhold is triggered
-- Also inactivity time before swap file is written to
vim.opt.updatetime = 250

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

vim.opt.autoread = true -- Automatically apply externally applied changes to open files.

vim.opt.autochdir = false
vim.opt.selection = "inclusive" -- When in visual mode, include the character under the cursor.
-- vim.opt.iskeyword:append("-") -- When selecting words with `w`, consider `-` to not be a separator.

vim.opt.maxmempattern = 20000 -- Allow more ram usage.

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- If we open a split, move focus to the newly opened (right or below) pane.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Vim looks for some keywords to determine if a file is PlainTeX, CoNTeXT, or LaTeX. This setting makes it revert to latex if keywords are not found.
vim.g.tex_flavor = "latex"
