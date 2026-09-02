--- Open (or create) a file in the same directory as the currently active buffer.

-- Directory of the current buffer, falling back to the working directory
local function buffer_dir()
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path == "" then
        return vim.fn.getcwd()
    end
    return vim.fn.fnamemodify(buf_path, ":p:h")
end

-- Edit `name` relative to the current buffer's directory, creating missing parent dirs
local function open_in_buffer_dir(name)
    name = vim.trim(name or "")
    if name == "" then
        return
    end

    local path = vim.fs.normalize(buffer_dir() .. "/" .. name)
    local parent = vim.fn.fnamemodify(path, ":h")
    if vim.fn.isdirectory(parent) == 0 then
        vim.fn.mkdir(parent, "p")
    end

    vim.cmd.edit({ args = { path } })
end

-- Ask for a filename, showing the directory it will end up in
local function prompt_open_in_buffer_dir()
    vim.ui.input({ prompt = "New file in " .. buffer_dir() .. "/", completion = "file" }, function(name)
        if name then
            open_in_buffer_dir(name)
        end
    end)
end

vim.api.nvim_create_user_command("OpenHere", function(opts)
    if opts.args == "" then
        prompt_open_in_buffer_dir()
    else
        open_in_buffer_dir(opts.args)
    end
end, {
    nargs = "?",
    complete = "file",
    desc = "Open a file in the directory of the current buffer",
})

vim.keymap.set(
    "n",
    "<leader>oh",
    prompt_open_in_buffer_dir,
    { desc = "Open file [H]ere (same directory as current buffer)" }
)
