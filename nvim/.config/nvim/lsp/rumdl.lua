-- Source:
-- https://github.com/neovim/nvim-lspconfig/blob/af9adce488c75ca0a81017945c2b7fa7b461bc23/lsp/rumdl.lua#L3
-- Newest: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/rumdl.lua
-- Modified based on https://rumdl.dev/lsp/#editor-configuration

local notes = require("notes")

---@type vim.lsp.Config
return {
    cmd = { "rumdl", "server" },
    filetypes = { "markdown" },
    -- Notes get their own client, so that symbols can be toggled per client in `before_init`.
    root_dir = function(bufnr, on_dir)
        if notes.contains_buffer(bufnr) then
            on_dir(notes.root)
        else
            on_dir(vim.fs.root(bufnr, ".git"))
        end
    end,
    init_options = {
        enableLinkCompletions = false,
        enableLinkNavigation = false,
    },
    -- Rule overrides
    settings = {
        lineLength = 100,
    },
    before_init = function(params, config)
        -- In notes this is already done by markdown_oxide
        local enable_symbols = config.root_dir ~= notes.root
        params.initializationOptions.enableSymbols = enable_symbols
        config.settings.enableSymbols = enable_symbols
    end,
}
