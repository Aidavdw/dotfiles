-- Git does not store where a branch came from,
-- so read it from the reflog (which expires after 90 days by default).
local function origin_branch()
    local branch = vim.trim(vim.fn.system({ "git", "branch", "--show-current" }))
    if vim.v.shell_error ~= 0 or branch == "" then
        return nil
    end

    local created = vim.fn.systemlist({ "git", "reflog", "show", "--format=%gs", "refs/heads/" .. branch })
    local source = (created[#created] or ""):match("^branch: Created from (.+)$")
    if source and source ~= "HEAD" then
        return (source:gsub("^refs/heads/", ""))
    end

    -- `git switch -c` logs "Created from HEAD", so find the branch we switched away from.
    local moves = vim.fn.systemlist({ "git", "reflog", "show", "--format=%gs", "HEAD" })
    for i = #moves, 1, -1 do
        local from = moves[i]:match("^checkout: moving from (.+) to " .. vim.pesc(branch) .. "$")
        if from then
            return from
        end
    end
    return nil
end

return {
    "https://github.com/sindrets/diffview.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "<leader>gl",
            "<cmd>DiffviewOpen<CR>",
            desc = "List of all changed files",
        },
        {
            "<leader>gL",
            function()
                local origin = origin_branch()
                if not origin then
                    vim.notify("Could not determine origin branch", vim.log.levels.WARN)
                    return
                end
                vim.cmd("DiffviewOpen " .. origin)
            end,
            desc = "List of changed files since origin branch",
        },
    },
    cmd = { "DiffviewOpen" },
}
