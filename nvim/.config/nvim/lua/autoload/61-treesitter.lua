-- Start (built-in) treesitter on opening some file types
-- https://github.com/nvim-treesitter/nvim-treesitter#folds
vim.api.nvim_create_autocmd("FileType", {
    -- Cannot just do this on *any* filetype, as it will also trigger with temporary / virtual files such as the spinner, fzf window.
    -- Instead, you have to manually keep this in sync with your enabled treesitter parsers.
    -- TODO: See if I can store this table higher up, and reference it for both the installer plugin and this guy.
    pattern = { "lua", "python", "javascript", "typescript", "typescriptreact", "rust", "go", "c", "c++" },
    callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
    end,
})

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
