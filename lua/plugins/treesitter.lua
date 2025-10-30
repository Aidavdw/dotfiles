return {
    -- Treesitter integration with buffers etc. is already built-in,
    -- but like with lspconfig, you'd need to manually set-up all
    -- configurations for each grammar type.
    -- Using this plugin, that is deferred to using maintained configurations.
    "nvim-treesitter/nvim-treesitter",
    -- NOTE: main branch =/= master is a rewrite.
    -- It will be leaner etc, but it is not feature-complete or stable yet.
    -- see https://github.com/nvim-lua/kickstart.nvim/pull/1657
    -- Will eventually change to main branch.
    branch = "master",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    -- Whenever a new grammar is added, rebuild everything to ensure it works together.
    build = "<cmd>TSUpdate",
    -- Normally, 'opts' below is passed to
    -- `require(MAIN_MODULE).setup(opts)`.
    -- For TreeSitter, it actually needs to be passed to:
    -- `require('nvim-treesitter.configs').setup(opts)`.
    main = "nvim-treesitter.configs",
    opts = {
        -- For some reason, if you edit this line errors might show up. This is fixed with a restart.
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "query",
            "vim",
            "vimdoc",
            "rust",
            "toml",
            "python",
            "bibtex",
            "cmake",
            "cpp",
            "css",
            "dot",
            "fortran",
            "hyprlang",
            "javascript",
            "json",
            "json5",
            "jsonc",
            "latex",
            "sql",
            "xml",
            "yaml",
        },
        -- Do not auto-install languages.
        -- I dont usually start using a new language, but when I do I should just
        -- add it to this config file.
        auto_install = false,
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { "ruby" },
            -- Disable slow treesitter highlight for large files
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        indent = { enable = true, disable = { "ruby" } },
        -- allows you to select around the cursor and dynamically grow it.
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<Enter>", -- set to `false` to disable one of the mappings
                node_incremental = "<Enter>",
                scope_incremental = "<TAB>",
                node_decremental = "<Backspace>",
            },
        },
    },
}
