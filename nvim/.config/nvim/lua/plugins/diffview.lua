return {
    "https://github.com/sindrets/diffview.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "<leader>gl",
            "<cmd>DiffviewOpen<CR>",
            desc = "List of all changed files",
        },
    },
    cmd = { "DiffviewOpen" },
}
