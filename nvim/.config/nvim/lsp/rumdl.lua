-- Source:
-- https://github.com/neovim/nvim-lspconfig/blob/af9adce488c75ca0a81017945c2b7fa7b461bc23/lsp/rumdl.lua#L3
-- Newest: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/rumdl.lua
-- Modified based on https://rumdl.dev/lsp/#editor-configuration

---@type vim.lsp.Config
return {
    cmd = { "rumdl", "server" },
    filetypes = { "markdown" },
    root_markers = { ".git" },
    init_options = {
        enableLinkCompletions = false,
        enableLinkNavigation = false,
        enableSymbols = false,
    },
    -- Rule overrides
    settings = {
        lineLength = 100,
        -- Already done by markdown_oxide
        enableSymbols = false,
    },
}
