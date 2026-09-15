--- Rename the file backing the current buffer, keeping the buffer (and window layout) alive.

-- Move `old` to `new`, preferring `git mv` so the rename stays staged in git.
-- Falls back to a plain rename when git refuses (not a repository, file untracked, ...).
local function move_file(old, new)
    local dir = vim.fn.fnamemodify(old, ":h")
    local git = vim.system({ "git", "-C", dir, "mv", "--", old, new }, { text = true }):wait()
    if git.code == 0 then
        return true
    end

    local ok, err = vim.uv.fs_rename(old, new)
    if not ok then
        return false, err
    end
    return true
end

-- Does `path` match one of the globs a server registered for this file operation?
-- No filters at all means the server never asked to hear about renames.
local function matches_filters(filters, path)
    for _, filter in ipairs(filters or {}) do
        local pattern = filter.pattern or {}
        local scheme_ok = filter.scheme == nil or filter.scheme == "file"
        local kind_ok = pattern.matches == nil or pattern.matches == "file"
        if scheme_ok and kind_ok and pattern.glob then
            local ok, lpeg = pcall(vim.glob.to_lpeg, pattern.glob)
            if ok and vim.lpeg.match(lpeg, path) then
                return true
            end
        end
    end
    return false
end

-- Attached or not, any client that registered interest in `path` should hear about the rename
local function clients_interested_in(operation, path)
    local interested = {}
    for _, client in ipairs(vim.lsp.get_clients()) do
        local file_operations = vim.tbl_get(client.server_capabilities or {}, "workspace", "fileOperations")
        local capability = file_operations and file_operations[operation]
        if capability and matches_filters(capability.filters, path) then
            table.insert(interested, client)
        end
    end
    return interested
end

local function rename_params(old, new)
    return { files = { { oldUri = vim.uri_from_fname(old), newUri = vim.uri_from_fname(new) } } }
end

-- Ask servers to prepare for the rename,
-- and apply the edits they hand back.
-- Must happen *before* the move: the edits target the old paths.
local function lsp_will_rename(old, new)
    for _, client in ipairs(clients_interested_in("willRename", old)) do
        local ok, response = pcall(function()
            return client:request_sync("workspace/willRenameFiles", rename_params(old, new), 1000)
        end)
        if ok and response and response.result then
            pcall(vim.lsp.util.apply_workspace_edit, response.result, client.offset_encoding)
        end
    end
end

-- Tell servers the rename happened,
-- so they can resync their own view of the workspace
local function lsp_did_rename(old, new)
    for _, client in ipairs(clients_interested_in("didRename", old)) do
        pcall(function()
            client:notify("workspace/didRenameFiles", rename_params(old, new))
        end)
    end
end

-- Point the current buffer at `new` without reopening it,
-- so the window layout is untouched
local function rename_buffer(new)
    new = vim.trim(new or "")
    if new == "" then
        return
    end

    local buf = vim.api.nvim_get_current_buf()
    local old = vim.api.nvim_buf_get_name(buf)
    if old == "" then
        vim.notify("Buffer has no file to rename", vim.log.levels.ERROR)
        return
    end

    -- A relative answer is relative to the buffer's own directory, like :OpenHere
    if not vim.startswith(new, "/") then
        new = vim.fn.fnamemodify(old, ":p:h") .. "/" .. new
    end
    new = vim.fs.normalize(new)

    if new == old then
        return
    end
    if vim.uv.fs_stat(new) then
        vim.notify(new .. " already exists", vim.log.levels.ERROR)
        return
    end

    -- Flush pending edits first: the move works on what is on disk
    if vim.bo[buf].modified then
        vim.cmd.write()
    end

    local parent = vim.fn.fnamemodify(new, ":h")
    if vim.fn.isdirectory(parent) == 0 then
        vim.fn.mkdir(parent, "p")
    end

    lsp_will_rename(old, new)

    local ok, err = move_file(old, new)
    if not ok then
        vim.notify("Rename failed: " .. tostring(err), vim.log.levels.ERROR)
        return
    end

    lsp_did_rename(old, new)

    vim.api.nvim_buf_set_name(buf, new)
    -- Re-read so 'filetype', LSP attachment and friends follow the new extension
    vim.api.nvim_buf_call(buf, function()
        vim.cmd.edit({ bang = true })
    end)

    -- nvim_buf_set_name leaves a stray buffer holding the old name behind
    local stale = vim.fn.bufnr(old)
    if stale ~= -1 and stale ~= buf then
        vim.api.nvim_buf_delete(stale, { force = true })
    end

    vim.notify("Renamed to " .. vim.fn.fnamemodify(new, ":~:."))
end

-- Ask for the new name,
-- pre-filled with the current one so a small edit is enough
local function prompt_rename_buffer()
    local old = vim.api.nvim_buf_get_name(0)
    if old == "" then
        vim.notify("Buffer has no file to rename", vim.log.levels.ERROR)
        return
    end

    vim.ui.input(
        { prompt = "Rename to: ", default = vim.fn.fnamemodify(old, ":t"), completion = "file" },
        function(name)
            if name then
                rename_buffer(name)
            end
        end
    )
end

vim.api.nvim_create_user_command("RenameBuffer", function(opts)
    if opts.args == "" then
        prompt_rename_buffer()
    else
        rename_buffer(opts.args)
    end
end, {
    nargs = "?",
    complete = "file",
    desc = "Rename the current buffer's file (git mv when possible)",
})

vim.keymap.set("n", "<leader>er", prompt_rename_buffer, { desc = "[E]dit: [R]ename current buffer's file" })
