-- Fancy rendering of markdown
return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    filetypes = { "markdown" },
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = { lsp = { enabled = true } },
        -- Make them more than just 1 line high,
        -- and add some spacing to the left.
        heading = {
            border = true,
            border_virtual = true,
            left_pad = 4,
        },
        code = {
            -- Language icon position
            -- Must be left if you allow line breaking, otherwise it renders outside of the visible area.
            position = "left",
            language_pad = 3,
            left_margin = 2,
            left_pad = 4,
            right_pad = 2,
            border = "thin",
        },
        bullet = {
            icons = { "• ", "⚬ " },
            left_pad = 2,
        },
        quote = { repeat_linebreak = true },
        -- This is here so that the quote bar is repeated for line breaks.
        -- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/BlockQuotes#break-works
        win_options = {
            showbreak = {
                default = vim.o.showbreak,
                rendered = "  ",
            },
            breakindent = {
                default = vim.o.breakindent,
                rendered = true,
            },
            breakindentopt = {
                default = vim.o.breakindentopt,
                rendered = "",
            },
        },
        latex = {
            enabled = true,
            bottom_pad = 1,
        },
    },
}

-- NOTE:
-- Line wrapping due to long urls that are hidden is unfortunately an nvim limitation.
-- Doesnt look like it'll be fixed anytime soon :(
-- https://github.com/neovim/neovim/issues/14409
