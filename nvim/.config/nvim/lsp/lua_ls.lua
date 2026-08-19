---@type table<string, vim.lsp.Config>
--- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
return {
    cmd = { "lua-language-server" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
    filetypes = { "lua" },
}
