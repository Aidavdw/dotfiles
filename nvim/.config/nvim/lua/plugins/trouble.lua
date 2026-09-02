-- 'Trouble' shows diagnostic information in a separate window for the entire project, not just the current file.
return {
    {
        "folke/trouble.nvim",
        opts = {
            -- Default open windows on the right
            win = { type = "split", position = "right", size = 52 },
            -- When opening, automatically take focus
            keys = {
                o = "jump",
                ["<cr>"] = "jump_close",
            },
        },
        cmd = "Trouble",
        keys = {
            -- Window showing just the errors:
            -- Not to get distracted with warnings, first just errors!
            -- also binding without auto-focus on capital.
            {
                "<leader>dwe",
                "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR filter.buf=0 focus=true<cr>",
                desc = "sidebar w/ errors (buffer, focused)",
            },
            {
                "<leader>dwE",
                "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR focus=true<cr>",
                desc = "sidebar w/ errors (workspace, focused)",
            },
            -- Same, but for entire workspace
            -- If you are fixing style for your entire project,
            -- its worth looking at workspace diagnostics,
            -- even if its a little overwhelming.
            {
                "<leader>dwD",
                "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR focus=true<cr>",
                desc = "sidebar w/ diagn. (workspace, focused)",
            },
            -- Basically same as error window, but now also hints and warnings.
            -- filter.buf=0 → Link to active buffer,
            -- otherwise you get overwhelmed quickly
            {
                "<leader>dwd",
                "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
                desc = "sidebar w/ diagn. (buffer, focused)",
            },
            -- Same, but for entire workspace
            -- If you are fixing style for your entire project,
            -- its worth looking at workspace diagnostics,
            -- even if its a little overwhelming.
            -- No 'unfocused' version of this, just use it to fix shit
            {
                "<leader>dwD",
                "<cmd>Trouble diagnostics toggle focus=true<cr>",
                desc = "sidebar w/ diagn. (workspace, focused)",
            },

            -- With markdown-oxide, this is also the TOC.
            {
                "<leader>sw",
                "<cmd>Trouble symbols toggle focus=true<cr>",
                desc = "toggle sidebar with symbols",
            },
        },
    },
}
