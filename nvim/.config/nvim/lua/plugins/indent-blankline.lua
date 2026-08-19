-- Add indentation guides even on blank lines
return {
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hiphish/rainbow-delimiters.nvim",
    },
    opts = {},
    config = function(_, opts)
        -- Integrate with indent_blankline
        -- https://github.com/lukas-reineke/indent-blankline.nvim?tab=readme-ov-file#rainbow-delimitersnvim-integration
        -- I don't care about supporting dynamically changing colour schemes though
        -- So I removed that part.
        opts.scope = opts.scope or {}
        -- Only set it if rainbow_delimiters exists
        opts.scope.highlight = vim.g.rainbow_delimiters and vim.g.rainbow_delimiters.highlight
        -- Note that some things that you think are 'scope' (such as tables in lua)
        -- are not actually scope- they are just an assignment.
        -- if you want all indentations to be coloured, use this:
        -- opts.indent = opts.indent or {}
        -- opts.indent.highlight = vim.g.rainbow_delimiters.highlight
        require("ibl").setup(opts)
    end,
}
