return {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    -- Only load when opening lua files
    ft = 'lua',
    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
    },
}

 -- { -- optional blink completion source for require statements and module annotations
 --    "saghen/blink.cmp",
 --    opts = {
 --      sources = {
 --        -- add lazydev to your completion providers
 --        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
 --        providers = {
 --          lazydev = {
 --            name = "LazyDev",
 --            module = "lazydev.integrations.blink",
 --            -- make lazydev completions top priority (see `:h blink.cmp`)
 --            score_offset = 100,
 --          },
 --        },
 --      },
 --    },
 --  }
