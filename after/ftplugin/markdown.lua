-- This file contains settings that are only applied to markdown files.
-- Keybinds must be set with `buffer = true`, if you don't want the bindings to be permanent for all buffers once it's been loaded.
vim.keymap.set("n", "<leader>Tr", function()
    require("render-markdown").toggle()
end, { desc = "[T]oggle: [R]ender markdown ", buffer = true })
