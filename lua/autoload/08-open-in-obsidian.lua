local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.WARN)
end

-- Convert a notes-relative path to an Obsidian URI
local function obsidian_uri_from_path(abs_path, notes_root)
    -- Normalize paths
    abs_path = vim.fn.fnamemodify(abs_path, ":p")
    notes_root = vim.fn.fnamemodify(notes_root, ":p")

    -- Ensure trailing slash on notes_root
    if not notes_root:match("/$") then
        notes_root = notes_root .. "/"
    end

    -- Ensure the file is inside notes_root
    if abs_path:sub(1, #notes_root) ~= notes_root then
        return nil, "File is not inside the notes directory"
    end

    -- Path relative to the vault root
    local rel_path = abs_path:sub(#notes_root + 1)

    -- URI-encode:
    -- 1. Escape percent first to avoid double-encoding
    -- 2. Replace spaces
    -- 3. Replace slashes for Obsidian nested paths
    rel_path = rel_path:gsub("%%", "%%25"):gsub(" ", "%%20"):gsub("/", "%%2F")

    local vault_name = "notes" -- folder name, not full path
    return string.format("obsidian://open?vault=%s&file=%s", vault_name, rel_path)
end

-- Open the current buffer in obsidian, if it is a note
function OpenInObsidian()
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path == "" then
        notify("Current buffer has no file path")
        return
    end

    local notes_root = vim.fn.expand("~/notes")

    local uri, err = obsidian_uri_from_path(buf_path, notes_root)
    if not uri then
        notify(err)
        return
    end

    local cmd = { "xdg-open", uri }
    local result = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
        notify("Failed to open file in Obsidian:\n" .. result, vim.log.levels.ERROR)
    end
end

vim.keymap.set("n", "<leader>nx", OpenInObsidian, { desc = "Open current buffer externally in [O]bsidian" })
