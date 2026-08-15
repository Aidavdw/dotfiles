-- Autocommands

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Automatically continue lists when inserting a new line
-- bullets.vim is too much,
-- and autolist.nvim is too buggy.
-- Modified from https://www.reddit.com/r/neovim/comments/1bis4h3/comment/kvmfjka
-- TODO: Move this to ftplugin?
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "tex", "text" },
    callback = function()
        vim.opt_local.formatoptions:append("r") -- `<CR>` in insert mode
        vim.opt_local.formatoptions:append("o") -- `o` in normal mode
        vim.opt_local.comments = {
            "b:- [ ]", -- tasks
            "b:- [x]",
            "b:- [X]",
            "b:*", -- unordered list
            "b:-",
            "b:+",
            "b:>", -- markdown quote
            "b:\\item", -- latex enumeration/list
        }
    end,
})

-- If you are looking for treesitter, we start those in ftplugin,
-- not with an autocommand.
-- This way we don't have language-specific things in here.
