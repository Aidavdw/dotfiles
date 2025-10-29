return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        lazy = false,
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "┷" },
                topdelete = { text = "┯" },
                changedelete = { text = "~" },
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
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, { desc = "Jump to next git [c]hange" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, { desc = "Jump to previous git [c]hange" })

                -- git stage
                map("n", "<leader>gsh", gitsigns.stage_hunk, { desc = "[G]it [S]tage [H]unk (toggle)" })
                map("n", "<leader>gsb", gitsigns.stage_buffer, { desc = "[G]it [S]tage [B]uffer" })
                -- git reset
                map("n", "<leader>grh", gitsigns.reset_hunk, { desc = "[G]it [R]eset [H]unk" })
                map("n", "<leader>grb", gitsigns.reset_buffer, { desc = "[G]it [R]eset [B]uffer" })

                -- Open a little popup window showing what has changed
                map("n", "<leader>ph", gitsigns.preview_hunk, { desc = "[P]opup git [H]unk" })

                -- Popup window showing git blame
                map("n", "<leader>pb", gitsigns.blame_line, { desc = "[P]opup git [B]lame" })
                -- Show changes in trouble window
                -- TODO: Check- I think this is not a thing?
                -- map('n', '<leader>wg', gitsigns.blame_line, { desc = '[W]indow: git hunks' })
                map("n", "<leader>wg", gitsigns.diffthis, { desc = "[W]indow: [G]it changes" })
                map("n", "<leader>wG", function()
                    gitsigns.diffthis("@")
                end, { desc = "[W]indow: [G]it changes (since last commit)" })
                -- Toggles display
                map(
                    "n",
                    "<leader>vgb",
                    gitsigns.toggle_current_line_blame,
                    { desc = "toggle [V]iew: [G]it [B]lame in line" }
                )
            end,
        },
    },
}
