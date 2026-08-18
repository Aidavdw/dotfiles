-- NOTE: For fold methods, I prefer to use treesitter's.
-- See the treesitter config.

vim.o.foldenable = true
vim.o.foldlevel = 99
-- Start folded at this level.
-- High number = don't start anything folded, except when the code is proper bad.
vim.opt.foldlevelstart = 6
-- If something is folded, everything inside of it might get folded too.
-- This limits how deep that is, so you don't end up unfolding everything 100 times.
vim.opt.foldnestmax = 4
-- Show a little column on the left with the nesting level.
-- If you make it wider (>1) then it will be like a contour,
-- which is cute but takes up a lot of space.
-- vim.o.foldcolumn = 1
-- TODO: merge the fold column with indent blankline
-- https://www.reddit.com/r/neovim/comments/1ag3uta/finally_the_combination_of_foldcolumn/

-- If this is empty, then it will still be syntax highlighted
vim.o.foldtext = ""

-- The characters used to denote a fold are defined in the 'visuals' file.
-- (Because it is a comma-separated string)

--- Fold all nodes matching a given treesitter-textobjects capture
--- (e.g. "function.outer", "class.outer") in the current buffer,
--- without touching any existing folds.
--- Requires:
--- - nvim-treesitter (with parser installed for the filetype)
--- - nvim-treesitter-textobjects (provides the e.g. `function.outer` capture)
local function fold_captures(capture_name)
    local bufnr = vim.api.nvim_get_current_buf()

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    if not ok or not parser then
        vim.notify("fold_captures: no treesitter parser for this buffer", vim.log.levels.WARN)
        return
    end

    -- The `:fold` command (like `zf`) only works when 'foldmethod' is
    -- "manual". Switching to "manual" does NOT delete or recompute existing
    -- folds -- it freezes whatever folds are currently there (regardless of
    -- how they were computed) and keeps them exactly as-is. So this is safe
    -- and we never need to clear anything.
    if vim.wo.foldmethod ~= "manual" then
        vim.wo.foldmethod = "manual"
    end

    local ranges = {}
    local seen = {}

    local function collect(tstree, lang)
        local ok_q, query = pcall(vim.treesitter.query.get, lang, "textobjects")
        if not ok_q or not query then
            return -- no textobjects query for this language, skip it
        end

        local root = tstree:root()
        for id, node in query:iter_captures(root, bufnr, 0, -1) do
            if query.captures[id] == capture_name then
                local start_row, _, end_row, end_col = node:range()
                local start_line = start_row + 1
                local end_line = (end_col == 0) and end_row or (end_row + 1)

                if end_line > start_line then
                    local key = start_line .. "-" .. end_line
                    if not seen[key] then
                        seen[key] = true
                        table.insert(ranges, { start_line, end_line })
                    end
                end
            end
        end
    end

    -- Recurse into the parser and any injected-language subtrees
    -- (e.g. embedded languages in markdown, vue, etc.)
    local function walk(lang_tree)
        for _, tstree in ipairs(lang_tree:trees()) do
            collect(tstree, lang_tree:lang())
        end
        for _, child in pairs(lang_tree:children()) do
            walk(child)
        end
    end

    walk(parser)

    -- Fold larger ranges first so nested nodes end up as nested folds.
    table.sort(ranges, function(a, b)
        return (a[2] - a[1]) > (b[2] - b[1])
    end)

    for _, r in ipairs(ranges) do
        vim.cmd(string.format("%d,%dfold", r[1], r[2]))
    end
end

local function fold_functions()
    fold_captures("function.outer")
end

local function fold_classes()
    fold_captures("class.outer")
end

vim.api.nvim_create_user_command("FoldFunctions", fold_functions, {})
vim.api.nvim_create_user_command("FoldClasses", fold_classes, {})

vim.keymap.set("n", "<leader>zf", fold_functions, { desc = "Fold all functions" })
vim.keymap.set("n", "<leader>zs", fold_classes, { desc = "Fold all classes" })
