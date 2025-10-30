-- Better tooling for rust than lspconfig with rust-analyzer.
return {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy,
    ["rust-analyzer"] = {
        cargo = { allFeatures = true },
    },
    -- BUG: luasnip does not play nice with the way how blink.cmp integration works for this plugin.
}
