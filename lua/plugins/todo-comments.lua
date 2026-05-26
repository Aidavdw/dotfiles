-- Highlight todo, notes, etc in comments
return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = {
        { "<leader>wt", "<cmd>Trouble todo focus=true<CR>", desc = "[W]indow: [T]odos" },
    },
}
