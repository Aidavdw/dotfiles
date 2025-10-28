-- We don't need lspconfig in the traditional sense anymore
-- Use native instead.
-- https://boltless.me/posts/neovim-config-without-plugins-2025/
-- Files are loaded from the ../lsp directory
vim.lsp.enable('lua_ls')
