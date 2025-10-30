-- This file contains settings that are only applied to rust files.
-- Keybinds must be set with `buffer = true`, if you don't want the bindings to be permanent for all buffers once it's been loaded.
vim.keymap.set("n", "<leader>ts", function()
    vim.cmd.RustLsp({ "testables" })
end, { desc = "[T]ests: [S]how all in buffer ", buffer = true })

vim.keymap.set("n", "<leader>ds", function()
    vim.cmd.RustLsp({ "debuggables" })
end, { desc = "[D]ebuggables: [S]how all in buffer ", buffer = true })

vim.keymap.set("n", "<leader>pe", function()
    vim.cmd.RustLsp({ "explainError", "current" })
end, { desc = "[P]opup: [E]xplain error ", buffer = true })

vim.keymap.set("n", "<leader>pD", function()
    vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, { desc = "[P]opup: [D]iagnostic (rustc) ", buffer = true })

vim.keymap.set("n", "gR", function()
    vim.cmd.RustLsp({ "relatedDiagnostics" })
end, { desc = "[G]oto [R]elated diagnostic ", buffer = true })

-- Override because it can have grouped code actions
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd.RustLsp("codeAction")
end, { desc = "Code action ", buffer = true })
