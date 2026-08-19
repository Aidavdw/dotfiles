-- [(())] different colours for different pairs of brackets!
return {
    "hiphish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- This plugin also has a .setup() function,
    -- while actually storing its info directly in vim.g.rainbow_delimiters
    -- as it is merely a TreeSitter extension.
    opts = {
        highlight = {
            -- Red is not very legible I think
            -- "RainbowDelimiterRed",
            "RainbowDelimiterOrange",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
        },
    },
    config = function(_, opts)
        require("rainbow-delimiters.setup").setup(opts)
    end,
}
