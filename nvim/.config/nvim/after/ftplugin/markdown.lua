-- This file contains settings that are only applied to markdown files.
-- Keybinds must be set with `buffer = true`, if you don't want the bindings to be permanent for all buffers once it's been loaded.
vim.keymap.set("n", "<leader>vr", function()
    require("render-markdown").toggle()
end, { desc = "Toggle: Render markdown ", buffer = true })

-- Sections map to 'classes' in the treesitter-textobjects sense.
-- This is really nice.
-- Some behaviour is a tiny bit unexpected though:
--'goto_previous_end' -> Takes you to the end of the current section
--'goto_next_end' -> Takes you to the end of the next (skipping this one) section
-- So Instead, we will override them so that they do this instead:
-- `sS` -> Goes to end of last non-empty line of this section.
-- First jump to the next header, and then going up until you find a line that has text.
-- If it is the last section, just go to the end of the file, and go back from there.
-- `Ss` -> Takes you to the last non-empty line under the previous section.
-- Can do the same as the function above, but now without first having to jump to the next header.
local move = require("nvim-treesitter-textobjects.move")
local capture = "@class.inner"
local query_group = "textobjects"

local function line_is_nonempty(line_number)
    local line = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
    return line and line:match("%S") ~= nil
end

local function line_length(line_number)
    local line = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
    return line and #line or 0
end

local function is_markdown_header(line_number)
    local line = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
    return line and line:match("^%s*#+%s+") ~= nil
end

local function current_header_line()
    local row = vim.api.nvim_win_get_cursor(0)[1]

    for line_number = row, 1, -1 do
        if is_markdown_header(line_number) then
            return line_number
        end
    end

    return nil
end

local function set_cursor_to_line_end(line_number)
    vim.api.nvim_win_set_cursor(0, {
        line_number,
        line_length(line_number),
    })
end

local function goto_end_of_current_section()
    local start_row = vim.api.nvim_win_get_cursor(0)[1]
    local current_header = current_header_line()

    local ok = pcall(function()
        move.goto_next_start(capture, query_group)
    end)

    local target_row = vim.api.nvim_win_get_cursor(0)[1]
    local moved_to_next_header = ok and target_row > start_row

    if not moved_to_next_header then
        target_row = vim.api.nvim_buf_line_count(0) + 1
    end

    local line_number = target_row - 1

    while line_number > (current_header or 1) and not line_is_nonempty(line_number) do
        line_number = line_number - 1
    end

    if line_number < (current_header or 1) then
        line_number = current_header or math.max(1, target_row - 1)
    end

    set_cursor_to_line_end(line_number)
end

local function goto_end_of_previous_section()
    local current_header = current_header_line()

    if not current_header then
        return
    end

    local original_row = vim.api.nvim_win_get_cursor(0)[1]

    pcall(function()
        move.goto_previous_start(capture, query_group)
    end)

    local previous_row = vim.api.nvim_win_get_cursor(0)[1]

    -- If the motion landed on the current header, move once more.
    if previous_row >= current_header and original_row > current_header then
        pcall(function()
            move.goto_previous_start(capture, query_group)
        end)

        previous_row = vim.api.nvim_win_get_cursor(0)[1]
    end

    if previous_row >= current_header then
        return
    end

    local line_number = current_header - 1

    while line_number > previous_row and not line_is_nonempty(line_number) do
        line_number = line_number - 1
    end

    -- Empty sections may fall back to their header.
    if line_number <= previous_row then
        line_number = previous_row
    end

    set_cursor_to_line_end(line_number)
end

vim.keymap.set({ "n", "x", "o" }, "]S", goto_end_of_current_section, {
    buffer = 0,
    desc = "End of current section  ",
})

vim.keymap.set({ "n", "x", "o" }, "[s", goto_end_of_previous_section, {
    buffer = 0,
    desc = "End of previous section  ",
})
