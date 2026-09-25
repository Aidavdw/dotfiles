-- ABC music notation language server (installed locally, not in nvim-lspconfig).
-- Ported from the lspconfig snippet in the abcls README.

---@type vim.lsp.Config
return {
    cmd = { "abcls", "lsp", "--stdio" },
    filetypes = { "abc" },
    root_markers = { ".git" },
}
