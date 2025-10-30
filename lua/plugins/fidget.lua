return {
    -- in the bottom right, little spinner etc for LSP
    "j-hui/fidget.nvim",
    -- Don't lazy load, as it redirects notifications.
    event = "VeryLazy",
    opts = {
        notification = {
            -- Automatically override vim.notify() with Fidget
            override_vim_notify = true,
            view = {
                -- Reflow (wrap) messages wider than notification window
                reflow = true,
            },
        },
    },
}
