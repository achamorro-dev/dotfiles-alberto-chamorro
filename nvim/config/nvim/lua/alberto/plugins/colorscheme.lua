return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			local flavour = vim.env.THEME_FLAVOUR

			require("catppuccin").setup({
				flavour = flavour,
				background = {
					-- :h background
					light = "latte",
					dark = "mocha",
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
	-- tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = { style = "moon" },
	},
}
