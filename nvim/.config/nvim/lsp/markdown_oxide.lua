-- Merged on top of the nvim-lspconfig defaults:
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/markdown_oxide.lua

local notes = require("notes")

---@type vim.lsp.Config
return {
    -- Only attach to files inside the notes vault: not calling `on_dir` means the server is not started.
    root_dir = function(bufnr, on_dir)
        if notes.contains_buffer(bufnr) then
            on_dir(notes.root)
        end
    end,
}
