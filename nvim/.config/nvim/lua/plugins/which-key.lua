return {
    -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VeryLazy", -- Sets the loading event to 'VimEnter'
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.opt.timeoutlen
        delay = 0,
        -- Easiest way to name some groups, without having to repeat the 'group' for every keybind.
        spec = {
            { "<leader>d", group = "[D]iagnostics" },
            { "<leader>dw", group = "[D]iagnostics: Toggle window" },
            { "<leader>D", group = "[D]ebugger" },
            { "<leader>v", group = "[V]isual" },
            { "<leader>e", group = "[E]dit action" },
            { "<leader>es", group = "[E]dit [S]wap" },
            { "<leader>g", group = "[G]it" },
            { "<leader>gs", group = "[G]it: [S]earch in" },
            { "<leader>gr", group = "[G]it [R]eset" },
            { "<leader>gs", group = "[G]it [S]tash" },
            { "<leader>gf", group = "[G]it [F]ind" },
            { "<leader>fg", group = "[F]ind [G]it" },

            -- when using a search/find, I arbitrarily make the distinction between:
            -- stuff on a file basis: Finding a file, and opening it. Re-opening an active buffer.
            { "<leader>o", group = "Open file" },
            { "<leader>n", group = "Notes (obsidian)" },
            { "<leader>?", group = "help" },
            -- Content of all files in workspace: Symbols in files, specific strings
            -- Deliberately on 's' in home row for colemak, because easier to reach. Most used.
            { "<leader>s", group = "[S]earch" },
            -- Find things that are not files or parts of text (that can be jumped to): Documentation, diagnostic, etc.
            { "<leader>/", group = "Search in.." },

            { "<leader>t", group = "[T]est" },
            { "<leader>T", group = "[T]oggle operation mode" },
            { "<leader>c", group = "[C]itations" },
            { "<leader>C", group = "spell [C]heck" },
            { "<leader>CT", group = "spell [C]heck: Toggle language" },
        },
    },
    keys = {
        {
            "<leader>?b",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
