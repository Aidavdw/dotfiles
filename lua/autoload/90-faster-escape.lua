-- <Esc> is very far away,
-- and I use <Caps> as extend layer key.
-- So, we want something a little faster to be able to escape.

local faster_escape = "hs"

-- Exit insert mode for graphite bros
vim.keymap.set("i", faster_escape, "<Esc>")

-- Exit fzf-lua pickers with the same
local fzf_group = vim.api.nvim_create_augroup("FzfLuaKeymaps", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = fzf_group,
    pattern = "fzf",
    callback = function(args)
        vim.keymap.set("t", faster_escape, "<Esc>", {
            buffer = args.buf,
            silent = true,
            nowait = true,
        })
    end,
})
