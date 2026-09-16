---@type LazySpec
return {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
        {
            "<leader>on",
            mode = { "n", "v" },
            "<cmd>Yazi<cr>",
            desc = "Open yazi at the current file",
        },
        {
            "<leader>op",
            "<cmd>Yazi cwd<cr>",
            desc = "Yazi in nvim's cmd",
        },
    },
    ---@type YaziConfig | {}
    opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = true,
        keymaps = {
            show_help = "<f1>",
        },
    },
    init = function()
        -- mark netrw as loaded so it's not loaded at all.
        -- using `open_for_directories=true`, this is recommended
        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        vim.g.loaded_netrwPlugin = 1
    end,
}
