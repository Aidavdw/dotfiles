return {
	-- Always load this colour scheme.
	lazy = false,
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
		    integrations = {
			-- cmp = true,
			-- gitsigns = true,
			-- nvimtree = true,
			-- notify = false,
			-- mini = {
			--    enabled = true,
			--     indentscope_color = "",
			-- },
		    }
		})
		-- Actually load the colour scheme
		vim.cmd.colorscheme "catppuccin-mocha"
	end
}

