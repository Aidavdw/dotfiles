return {
    -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
        -- Better Around/Inside textobjects
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require("mini.ai").setup({ n_lines = 500 })

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        -- Examples:
        -- `saw(` - add '(' around word
        -- `sa$'` - add `'` from this point up until the end of the line.
        -- `sr[(` - replace surrounding '[]' with '()', e.g. 'some (text  and) more' ￫ 'some [text and] more'
        -- `sd[` - replace surrounding '[]' with '()', e.g. 'some (text  and) more' ￫ 'some text and]more'
        -- require("mini.surround").setup()

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require("mini.statusline")
        -- set use_icons to true if you have a Nerd Font
        statusline.setup({ use_icons = vim.g.have_nerd_font })

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return "%2l:%-2v"
        end

        -- When inserting a '(', also automatically insert a ')' (closing pairs, also for others like ({['``']})
        require("mini.pairs").setup()
        -- Filetype icons
        require("mini.icons").setup()

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
    end,
}
