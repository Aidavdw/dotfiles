-- Highlight todo, notes, etc in comments
return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = {
        { "<leader>Tw", "<cmd>Trouble todo focus=true<CR>", desc = "Open side-panel with todos" },
    },
}
