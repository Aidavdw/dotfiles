return {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre" },
    opts = {
        max_lines = 5,
        multiline_threshold = 1, -- collapse multi-line signatures to one line
        trim_scope = "outer", -- when over max_lines, drop outermost first
        mode = "cursor", -- context follows the cursor, not the topline
        separator = "─", -- a rule between context and code
    },
    keys = {
        {
            "[s",
            function()
                require("treesitter-context").go_to_context()
            end,
            desc = "Jump to context",
        },
    },
}
