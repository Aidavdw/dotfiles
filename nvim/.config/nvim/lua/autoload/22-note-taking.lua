vim.keymap.set("n", "<leader>ot", function()
    local todo_file = vim.fn.expand("~/notes/todo.md")
    vim.cmd("edit " .. vim.fn.fnameescape(todo_file))
end, { desc = "Open todo list" })
