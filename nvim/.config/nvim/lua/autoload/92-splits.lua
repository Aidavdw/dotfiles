-- Switch windows quickly
vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>w", { noremap = true, silent = true, desc = "Switch active split" })
vim.keymap.set("n", "<C-h>", "<C-w>w", { noremap = true, silent = true })

-- Resize splits with Ctrl+h/a
-- Only provide keys for increase,
vim.keymap.set("n", "<C-p>", "4<C-W>+", {
    noremap = true,
    silent = true,
    desc = "Increase split height",
})
vim.keymap.set("n", "<C-,>", "4<C-W>>", {
    noremap = true,
    silent = true,
    desc = "Increase split width",
})
