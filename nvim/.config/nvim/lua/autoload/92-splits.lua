-- Switch windows quickly
vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>w", { noremap = true, silent = true, desc = "Switch active split" })
vim.keymap.set("n", "<C-h>", "<C-w>w", { noremap = true, silent = true })

-- Resize splits with Ctrl+p/,
-- With shift for vertical (horizontal is more important)
vim.keymap.set("n", "<C-,>", "4<C-W>+", {
    noremap = true,
    silent = true,
    desc = "+ window height",
})
vim.keymap.set("n", "<C-p>", "4<C-W>-", {
    noremap = true,
    silent = true,
    desc = "- window height",
})

vim.keymap.set("n", "<C-S-p>", "4<C-W>>", {
    noremap = true,
    silent = true,
    desc = "+ window width",
})

vim.keymap.set("n", "<C-S-,>", "4<C-W><", {
    noremap = true,
    silent = true,
    desc = "+ window width",
})

-- 'p' menu for more complicated stuff
vim.keymap.set("n", "<leader>ps", "<C-W>s", {
    noremap = true,
    silent = true,
    desc = "Split window horizontally",
})

vim.keymap.set("n", "<leader>pv", "<C-W>v", {
    noremap = true,
    silent = true,
    desc = "Split window vertically",
})

-- `wincmd` is equivalent to the ctrl-w thing.
vim.keymap.set("n", "<leader>pr", "<cmd>wincmd =<cr>", {
    noremap = true,
    silent = true,
    desc = "Resize panes to equal size",
})
