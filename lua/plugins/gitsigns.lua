-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
    -- Must always load, as it has functionality in netrw too.
    lazy = false,
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "┷" },
            topdelete = { text = "┯" },
            changedelete = { text = ";" },
            untracked = { text = "┆" },
        },
        -- Add keybinds for this git signs here, because not lazily loaded anyway
        -- This is the way the plugin author suggests it.
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]g", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]g", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, { desc = "Jump to next [g]it change" })

            map("n", "[g", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[g", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, { desc = "Jump to previous git [c]hange" })

            -- git stage
            map("n", "<leader>gsh", gitsigns.stage_hunk, { desc = " git stage [H]unk (toggle)" })
            map("n", "<leader>gsb", gitsigns.stage_buffer, { desc = "git stage entire [B]uffer" })
            -- git reset
            map("n", "<leader>grh", gitsigns.reset_hunk, { desc = "git reset [H]unk" })
            map("n", "<leader>grb", gitsigns.reset_buffer, { desc = "git reset entire [B]uffer" })

            -- Open a little popup window showing what has changed
            map("n", "<leader>gc", gitsigns.preview_hunk, { desc = "git pop-up [C]hanges" })

            -- Popup window showing git blame
            map("n", "<leader>gb", gitsigns.blame_line, { desc = "git pop-up [B]lame" })
            -- Show changes in trouble window
            -- TODO: Check- I think this is not a thing?
            -- map('n', '<leader>wg', gitsigns.blame_line, { desc = '[W]indow: git hunks' })
            map("n", "<leader>gd", gitsigns.diffthis, { desc = "open [D]iff view (window)" })
            map("n", "<leader>gD", function()
                gitsigns.diffthis("@")
            end, { desc = "open [D]iff view (window, since last commit)" })
            -- Toggles display
            map("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "toggle view inline [B]lame" })
        end,
    },
}
