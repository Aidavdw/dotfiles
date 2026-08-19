-- We define keymaps outside, because that allows us to use a nicer helper method.
-- This should not really be lazily loaded anyway.
local function map_select_textobject(partial_keys, capture, label)
    vim.keymap.set({ "x", "o" }, partial_keys, function()
        require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
    end, { desc = label })
end
map_select_textobject("af", "@function.outer", "Around function")
map_select_textobject("if", "@function.inner", "Inside function")
map_select_textobject("ac", "@class.outer", "Around class/struct")
map_select_textobject("ic", "@class.inner", "Inside class/struct")

-- Swapping text objects
vim.keymap.set("n", "<leader>es", function()
    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end, { desc = "Swap with next (textobject, arg in fun)" })
vim.keymap.set("n", "<leader>eS", function()
    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
end, { desc = "Swap with prev. (textobject, arg in fun)" })

local function map_goto_next_start(partial_key, capture, label)
    vim.keymap.set({ "n", "x", "o" }, "]" .. partial_key, function()
        require("nvim-treesitter-textobjects.move").goto_next_start(capture, "textobjects")
    end, { desc = "Goto start of next " .. label })
end
-- Vim does have "[m" built-in, but that is pased on syntax parse, not treesitter.
-- What we provide here is superior.
-- Also, I think 'f' for 'function' is more intuitive and nicer to reach than 'm' for method.
map_goto_next_start("f", "@function.inner", "function")
map_goto_next_start("o", { "@loop.inner", "@loop.outer" }, "loop")
-- This overwrites the 'goto next typo' if we do not use the square bracket remapping.
map_goto_next_start("s", "@class.inner", "class")

-- And the opposite- going to the (start of) the previous one
local function map_goto_prev_start(partial_key, capture, label)
    vim.keymap.set({ "n", "x", "o" }, "[" .. partial_key, function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(capture, "textobjects")
    end, { desc = "Goto start of previous " .. label })
end
map_goto_prev_start("F", "@function.inner", "function")
map_goto_prev_start("S", "@class.inner", "class")

-- bring you to the end of the current {function}
local function map_goto_next_end_textobject(partial_key, capture, label)
    vim.keymap.set({ "n", "x", "o" }, "]" .. partial_key, function()
        require("nvim-treesitter-textobjects.move").goto_next_end(capture, "textobjects")
    end, { desc = "Goto end of next " .. label })
end
-- I swapped the capitalisation on this:
-- If you now do 'SS', you can go back to the start.
-- This is the more common operation.
-- Having to do the 'Ss' is a lot more finger yoga.
map_goto_next_end_textobject("F", "@function.outer", "function")
map_goto_next_end_textobject("S", "@class.outer", "class")

local function map_goto_previous_end_textobject(partial_key, capture, label)
    -- Does not make too much sense to map 'goto_next_end',
    -- you probably call this when you are inside a function
    vim.keymap.set({ "n", "x", "o" }, "[" .. partial_key, function()
        require("nvim-treesitter-textobjects.move").goto_previous_end(capture, "textobjects")
    end, { desc = "Goto end of previous " .. label })
end
map_goto_previous_end_textobject("f", "@function.outer", "function")
map_goto_previous_end_textobject("s", "@class.outer", "class")

-- The folds setting isn't too useful, as it just jumps to something that *can be* folded.
-- vim.keymap.set({ "n", "x", "o" }, "]z", function()
--     require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
-- end)

return {
    -- functionality like 'go to next function' or
    -- 'go to next paragraph'
    -- See:
    -- https://ofirgall.github.io/learn-nvim/chapters/05-text-objects.html
    -- https://www.josean.com/posts/nvim-treesitter-and-textobjects
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {},
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        select = {
            -- e.g. if you are in a class, also allows it to
            -- find the next class it can find.
            lookahead = true,
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V", -- linewise
                -- ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = false,
        },
    },
}
