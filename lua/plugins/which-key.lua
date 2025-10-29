return {
    -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      -- Easiest way to name some groups, without having to repeat the 'group' for every keybind.
      spec = {
        { '<leader>d', group = '[D]ebugger' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>g', group = '[G]it / [G]oto' },
        { '<leader>gr', group = '[G]it [R]eset' },
        { '<leader>gs', group = '[G]it [S]tash' },

        -- when using a search/find, I arbitrarily make the distinction between:
        -- stuff on a file basis: Finding a file, and opening it. Re-opening an active buffer.
        { '<leader>o', group = '[O]pen (file, buffer)' },
        -- Content of all files in workspace: Symbols in files, specific strings
        -- Deliberately on 's' in home row for colemak, because easier to reach. Most used.
        { '<leader>s', group = '[S]earch in workspace for (text, symbols)' },
        { '<leader>b', group = '[B]uffer' },
        -- Content of this current buffer (same as above but limited)
        { '<leader>b', group = 'search in this [B]uffer for (text, symbols)' },
        -- External things: Documentation, diagnostic, etc.
        { '<leader>f', group = '[F]ind in (docs, help, external resources)' },

        { '<leader>t', group = '[T]est' },
        { '<leader>c', group = '[C]itations' },
        { '<leader>p', group = '[P]opup show' },
        { '<leader>v', group = 'toggle [V]iew' },
        { '<leader>vg', group = 'toggle [V]iew [G]it' },
        { '<leader>w', group = 'show/hide [W]indow' },
      },
    },
    keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
