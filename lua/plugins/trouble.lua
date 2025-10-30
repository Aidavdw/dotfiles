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
                "<leader>we",
                "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR focus=true<cr>",
                desc = "[W]indow: [E]rrors",
            },
            {
                "<leader>wE",
                "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
                desc = "[W]indow: [E]rrors (no focus)",
            },
            -- Basically same as error window, but now also hints and warnings.
            -- filter.buf=0 → Link to active buffer,
            -- otherwise you get overwhelmed quickly
            {
                "<leader>wd",
                "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
                desc = "[W]indow: [D]iagnostics",
            },
            {
                "<leader>wD",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "[W]indow: [D]iagnostics (no focus)",
            },
            -- With markdown-oxide, this is also the TOC.
            {
                "<leader>ws",
                "<cmd>Trouble symbols toggle focus=true<cr>",
                desc = "[W]indow: [S]ymbols outline",
            },
            {
                "<leader>wS",
                "<cmd>Trouble symbols toggle<cr>",
                desc = "[W]indow: [S]ymbols outline (no focus)",
            },
        },
    },
}
