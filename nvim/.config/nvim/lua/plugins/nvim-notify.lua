local function show_history_in_buffer()
    local notifications = require("notify").history()
    local lines = {}

    for _, notification in ipairs(notifications) do
        local timestamp = os.date("%H:%M:%S", notification.time)
        local level = notification.level or "INFO"

        table.insert(lines, string.format("[%s] %s", timestamp, level))

        -- nvim-notify stores the message as a list of lines
        vim.list_extend(lines, notification.message)

        table.insert(lines, "")
    end

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "notify"

    vim.cmd("botright new")
    vim.api.nvim_win_set_buf(0, buf)

    vim.wo.wrap = true
    vim.wo.cursorline = true
end

return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        vim.notify = require("notify")
    end,
    keys = {
        {
            "<leader>vn",
            show_history_in_buffer,
            desc = "Show notification history in buffer",
        },
    },
}
