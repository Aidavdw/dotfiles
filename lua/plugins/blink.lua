return {
    -- Autocompletion
    "saghen/blink.cmp",
    -- This is pretty integrated:
    -- automatically extends LSP
    -- So it must always be loaded, even if it is a heavier plugin :(
    lazy = false,
    version = "1.*",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "folke/lazydev.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        keymap = {
            -- 'default' (recommended) for mappings similar to built-in completions
            --   <c-y> to accept ([y]es) the completion.
            --    This will auto-import if your LSP supports it.
            --    This will expand snippets if the LSP sent a snippet.
            -- 'super-tab' for tab to accept
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- For an understanding of why the 'default' preset is recommended,
            -- you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            --
            -- All presets have the following mappings:
            -- <tab>/<s-tab>: move to right/left of your snippet expansion
            -- <c-space>: Open menu or open docs if already open
            -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
            -- <c-e>: Hide menu
            -- <c-k>: Toggle signature help
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            preset = "default",

            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },

        completion = {
            -- By default, you may press `<c-space>` to show the documentation.
            -- Optionally, set `auto_show = true` to show the documentation after a delay.
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },

        sources = {
            -- FIXME: With how blink is set up, you can only register sources at config time.
            -- This means that lazydev must always be loaded, even when you're not in a lua file.
            default = { "lsp", "path", "snippets", "lazydev" },
            providers = {
                lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
            },
        },

        snippets = { preset = "luasnip" },

        -- Prefer the rust 'frizbee' fuzzy matcher.
        -- https://github.com/Saghen/frizbee/?tab=readme-ov-file
        -- Auto-installs if able,
        -- otherwise falls back to lua.
        fuzzy = { implementation = "prefer_rust_with_warning" },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
    },
}
