return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function(_, opts)
        local fzf = require("fzf-lua")
        fzf.setup(opts)
        fzf.register_ui_select()
    end,
    keys = {
        -- [F]ind pickers. These is the broadest level.
        {
            "<leader>fh",
            function()
                require("fzf-lua").helptags()
            end,
            desc = "[F]ind in [H]elp",
        },
        {
            "<leader>fk",
            function()
                require("fzf-lua").keymaps()
            end,
            desc = "[F]ind [K]eymaps",
        },
        {
            "<leader>fo",
            function()
                require("fzf-lua").builtin()
            end,
            desc = "[F]ind [O]ther (picker picker)",
        },
        {
            "<leader>fd",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            desc = "[F]ind in [D]iagnostics (document)",
        },
        {
            "<leader>fD",
            function()
                require("fzf-lua").diagnostics_workspace()
            end,
            desc = "[F]ind in [D]iagnostics (workspace)",
        },
        {
            "<leader>fa",
            function()
                require("fzf-lua").resume()
            end,
            desc = "[F]ind previous search [A]gain",
        },
        {
            "<leader>fgc",
            function()
                require("fzf-lua").git_commits()
            end,
            desc = "[F]ind in [G]it [C]ommits",
        },

        -- [O]pen pickers. For switching buffers, opening new files.
        {
            "<leader>of",
            function()
                require("fzf-lua").files()
            end,
            desc = "[O]pen [F]ile",
        },
        {
            "<leader>ob",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[O]pen [B]uffer",
        },
        {
            "<leader>oo",
            function()
                require("fzf-lua").files({ cwd = "~/notes" })
            end,
            desc = "[O]pen [O]bsidian note",
        },
        {
            "<leader>od",
            function()
                require("fzf-lua").files({ cwd = "~/dotfiles" })
            end,
            desc = "[O]pen [D]otfiles",
        },
        {
            "<leader>oc",
            function()
                local appname = vim.env.NVIM_APPNAME or "nvim"
                local path = string.format("%s/.config/%s", vim.fn.expand("~"), appname)
                require("fzf-lua").files({ cwd = path })
            end,
            desc = "[O]pen nvim [C]onfig",
        },
        {
            "<leader>or",
            function()
                require("fzf-lua").oldfiles()
            end,
            desc = "[O]pen [R]ecent",
        },

        -- [S]earch pickers. Look through the contents of
        -- a file or buffer, and jump to it
        {
            "<leader>sg",
            function()
                require("fzf-lua").live_grep_native()
            end,
            desc = "Live [G]rep (contents of cwd)",
        },
        {
            "<leader>so",
            function()
                require("fzf-lua").live_grep_native({ cwd = "~/notes" })
            end,
            desc = "[S]earch inside [O]bsidian notes",
        },
        {
            "<leader>sa",
            function()
                require("fzf-lua").resume()
            end,
            desc = "[S]earch previous [A]gain",
        },
        {
            "<leader>sw",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "[S]earch for [W]ord under cursor",
        },
        {
            -- Finds all the misspelled words in the buffer
            "<leader>st",
            desc = "[S]earch for [T]ypos in buffer",
            function()
                require("fzf-lua").spellcheck()
            end,
        },
        {
            "<leader>fgh",
            function()
                require("fzf-lua").git_hunks()
            end,
            desc = "[F]ind in [G]it [H]unks",
        },
        {
            -- This is a pop-up to correct the word under the cursor
            "<leader>et",
            desc = "[E]dit: Correct [T]ypo",
            function()
                require("fzf-lua").spell_suggest()
            end,
        },
    },
}
