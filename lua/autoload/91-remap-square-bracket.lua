-- remaps `[<key>` and `]<key>` to `s<key>` and `S<key>`
-- Be sure this is called *after* loading the plugins- then their bindings will also automatically be changed.
vim.keymap.set("n", "s", "]", { remap = true })
vim.keymap.set("n", "S", "[", { remap = true })

-- We also remap specifically 'go to next spelling error', because we want to have `ss` and `Ss` etc. for symbols/classes/headers.

vim.keymap.set("n", "sw", "]s")
vim.keymap.set("n", "Sw", "[s")
