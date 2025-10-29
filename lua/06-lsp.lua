-- We don't need lspconfig in the traditional sense any more.
-- However, it still gives nice presets for lsp configurations.
-- so for LSPs where we just want to use a 'default' configuration
-- we can just 'enable()' here and that's it.
-- you can still customise it though, for which you'd place a file in the
-- ../lsp directory.
-- https://0xunicorn.com/neovim-native-lsp-config/
vim.lsp.enable({
    'lua_ls',
    'clangd',
    'cmake',
    'cssls',
    -- Fortran
    'fortls',
    'html',
    'texlab',
    -- Python static type checker
    'basedpyright',
    -- Python linter
    'ruff',
    -- Obsidian-like markdown
    'markdown-oxide',
})
