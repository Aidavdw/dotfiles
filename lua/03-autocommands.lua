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

-- Start (built-in) treesitter on opening some file types
vim.api.nvim_create_autocmd("FileType", {
    -- Cannot just do this on *any* filetype, as it will also trigger with temporary / virtual files such as the spinner, fzf window.
    -- Instead, you have to manually keep this in sync with your enabled treesitter parsers.
    -- TODO: See if I can store this table higher up, and reference it for both the installer plugin and this guy.
    pattern = { "python", "javascript", "typescript", "typescriptreact", "rust", "go", "c", "c++" },
    callback = function()
        vim.treesitter.start()
    end,
})
