return {
    -- functionality like 'go to next function' or
    -- 'go to next paragraph'
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects"
    },
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    main = 'nvim-treesitter.configs',
    opts = {
        textobjects = {
            select = {
                enable = true,
                -- e.g. if you are in a class, also allows it to 
                -- find the next class it can find.
                lookahead = true,
                keymaps = {
                    -- TODO: Update based on 
                    -- https://www.josean.com/posts/nvim-treesitter-and-textobjects
                    -- Add combinations that can come after 'v', e.g. 'vaf'
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = { query = "@function.outer", desc = "Select around function" },
                    ["if"] = { query = "@function.inner", desc = "Select inside function" },
                    ["al"] = { query = "@class.outer", desc = "Select around struct/class" },
                    ["il"] = { query = "@class.inner", desc = "Select inside struct/class" },
                    -- You can also use captures from other query groups like `locals.scm`
                    -- ["a{"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope, e.g. {...} " },
                },
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V', -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace.
                include_surrounding_whitespace = true,
            },
            -- Swapping the arguments in a function, two entries in an array, etc
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>esa"] = {query = "@parameter.inner", desc = "[S]wap [A]rgs/elements (in function, array)"},
                    ["<leader>esf"] = {query = "@function.outer", desc = "[S]wap [F]unction with next"},
                },
                swap_previous = {
                    ["<leader>esA"] = {query = "@parameter.inner", desc = "[S]wap [A]rgs/elements backwards"},
                    ["<leader>esF"] = {query = "@function.outer", desc = "[S]wap [F]unction with previous"},
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {

                    -- TODO: Update based on 
                    -- https://www.josean.com/posts/nvim-treesitter-and-textobjects
                    ["]f"] = { query = "@function.outer", desc = "goto next function" },
                    ["]l"] = { query = "@class.outer", desc = "goto next struct/class" },
                    -- e.g. in rust stuff between `{}`.
                    -- TODO: fix, does not work yet as expected.
                    -- There is already built-in functionality for `]}`, but `]{`
                    -- does not work.
                    ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                },
                goto_next_end = {
                    ["]F"] = { query = "@function.outer", desc = "end of function" },
                    ["]L"] = { query = "@function.outer", desc = "end of class" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer", desc = "Previous function" },
                    ["[L"] = { query = "@class.outer", desc = "Next class" },
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[L"] = "@class.outer",
                },
            },
        },
    }
}
