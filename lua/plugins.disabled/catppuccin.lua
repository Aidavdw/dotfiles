return {
    -- Always load this colour scheme.
    lazy = false,
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        integrations = {
            -- cmp = true,
            gitsigns = true,
            -- nvimtree = true,
            -- notify = false,
            -- mini = {
            --    enabled = true,
            --     indentscope_color = "",
            -- },
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        -- Actually load the colour scheme
        vim.cmd.colorscheme("catppuccin-mocha")
    end,
}
