return {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
        end
        return "make install_jsregexp"
    end)(),
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
    },
    opts = {},
    config = function(_, opts)
        local luasnip = require("luasnip")
        luasnip.setup(opts)
        -- load snippets, with support for multiple profiles using NVIM_APPNAME
        local appname = vim.env.NVIM_APPNAME or "nvim"
        local paths = {
            string.format("%s/.config/%s/lua/snippets", vim.fn.expand("~"), appname),
            -- string.format("%s/.config/nvim/lua/snippets", vim.fn.expand("~")), -- fallback/global snippets
        }
        require("luasnip.loaders.from_lua").lazy_load({ paths = paths })
    end,
}
