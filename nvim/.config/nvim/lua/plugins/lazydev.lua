return {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    -- Only load when opening lua files
    ft = "lua",

    -- https://github.com/Saghen/blink.cmp/issues/1070
    specs = {
        { "saghen/blink.cmp", opts = { sources = { default = { "lazydev" } } } },
    },

    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
