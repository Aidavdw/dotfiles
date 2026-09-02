return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {
        grep = {
            -- Do not use --color=always, this will break it.
            -- rg_opts = "--hidden --follow --column --line-number --no-heading --smart-case -g '!{.git,node_modules, target}/*'",
            follow = true, -- Follow symlinks
            hidden = true, -- Also search inside hidden files
        },
        files = {
            follow = false, -- Follow symlinks
            hidden = true, -- Also search inside hidden files
        },
    },
    config = function(_, opts)
        local fzf = require("fzf-lua")
        fzf.setup(opts)
        fzf.register_ui_select()
    end,
    keys = {
        -- Help
        {
            "<leader>?n",
            function()
                require("fzf-lua").helptags()
            end,
            desc = "search in [N]eovim help",
        },
        {
            "<leader>?k",
            function()
                require("fzf-lua").keymaps()
            end,
            desc = "search in [K]eymaps",
        },
        -- Diagnostics
        {
            "<leader>ds",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            desc = "search in diagnostics (of buffer)",
        },
        {
            "<leader>dS",
            function()
                require("fzf-lua").diagnostics_workspace()
            end,
            desc = "search in diagnostics (of workspace)",
        },
        -- Broad 'Search'/find category
        -- 'find' rather than 'search', so I can use 's' for lsp symbols
        {
            "<leader>/a",
            function()
                require("fzf-lua").resume()
            end,
            desc = "repeat search (prev)",
        },
        {
            "<leader>/f",
            function()
                require("fzf-lua").builtin()
            end,
            desc = "find among finds (picker picker)",
        },
        {
            "<leader>//",
            function()
                require("fzf-lua").live_grep_native()
            end,
            desc = "Live Grep (contents of cwd)",
        },
        {
            "<leader>/a",
            function()
                require("fzf-lua").resume()
            end,
            desc = "[S]earch previous [A]gain",
        },
        {
            "<leader>/w",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "[S]earch for [W]ord under cursor",
        },
        {
            "<leader>/c",
            function()
                local appname = vim.env.NVIM_APPNAME or "nvim"
                local path = string.format("%s/.config/%s", vim.fn.expand("~"), appname)
                require("fzf-lua").live_grep_native({ cwd = path })
            end,
            desc = "[S]earch within neovim config",
        },
        -- Broad 'open' category
        {
            "<leader>of",
            function()
                require("fzf-lua").files()
            end,
            desc = "[O]pen [F]ile in cwd",
        },
        {
            "<leader>ob",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[O]pen [B]uffer",
        },
        {
            "<leader>od",
            function()
                require("fzf-lua").files({ cwd = "~/dotfiles" })
            end,
            desc = "[O]pen [D]otfile",
        },
        {
            "<leader>oc",
            function()
                local appname = vim.env.NVIM_APPNAME or "nvim"
                local path = string.format("%s/.config/%s", vim.fn.expand("~"), appname)
                require("fzf-lua").files({ cwd = path })
            end,
            desc = "open nvim config file",
        },
        {
            "<leader>or",
            function()
                require("fzf-lua").oldfiles()
            end,
            desc = "open [R]ecent",
        },
        -- Git
        {
            "<leader>g/c",
            function()
                require("fzf-lua").git_commits()
            end,
            desc = "[S]earch in [C]ommits",
        },
        {
            "<leader>g/h",
            function()
                require("fzf-lua").git_hunks()
            end,
            desc = "[F]ind in [G]it [H]unks",
        },
        -- Notes (Obsidian)
        {
            "<leader>no",
            function()
                require("fzf-lua").files({ cwd = "~/notes" })
            end,
            desc = "[O]pen note [F]ile",
        },
        {
            "<leader>ns",
            function()
                require("fzf-lua").live_grep_native({ cwd = "~/notes" })
            end,
            desc = "[O]bsidian notes: [S]earch within",
        },

        -- Spellcheck
        {
            -- Finds all the misspelled words in the buffer
            "<leader>Cs",
            desc = "[S]earch for [T]ypos in buffer",
            function()
                require("fzf-lua").spellcheck()
            end,
        },
        {
            -- This is a pop-up to correct the word under the cursor
            "<leader>CC",
            desc = "fuzzy-search spelling corr. for word under cursor",
            function()
                require("fzf-lua").spell_suggest()
            end,
        },
    },
}
