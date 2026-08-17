-- Sets how neovim will display certain whitespace characters in the editor.
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "␣",
    nbsp = "␣",
    multispace = "·",
    -- So that space instead of tab for indentation does not mess you up
    leadmultispace = " ",
}

-- Render a tab as 4 spaces
vim.opt.tabstop = 4
-- amount to indent with `>>` or `<<`
vim.opt.shiftwidth = 4
-- amount of spaces to enter when pressing `Tab`.
-- NOTE: This is overridden by the 'guess-indentation plugin'
vim.opt.softtabstop = 4

-- When at beginning of line, translate pressing 'tab' to the '>>' command.
vim.opt.smarttab = true
vim.opt.smartindent = true
-- Convert tabs to spaces
vim.opt.expandtab = true
-- Keep indentation from previous line.
vim.opt.autoindent = true
