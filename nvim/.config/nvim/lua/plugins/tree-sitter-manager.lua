return {
    "romus204/tree-sitter-manager.nvim",
    lazy = true,
    cmd = { "TSManager", "TSInstall", "TSUninstall" },
    dependencies = {}, -- Requires treesitter cli to be installed.
    config = function()
        require("tree-sitter-manager").setup({
            -- Default Options
            -- ensure_installed = {}, -- list of parsers to install at the start of a neovim session. If set to "all", install all parsers.
            -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
            -- auto_install = false, -- if enabled, install missing parsers when editing a new file
            -- highlight = true, -- treesitter highlighting is enabled by default
            -- languages = {}, -- override or add new parser sources
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
        })
    end,
}
