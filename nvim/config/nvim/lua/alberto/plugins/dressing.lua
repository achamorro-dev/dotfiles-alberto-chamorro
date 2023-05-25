-- better vim.ui
return {
	"stevearc/dressing.nvim",
	lazy = true,
	init = function()
		local lazy = require("lazy")
		vim.ui.select = function(...)
			lazy.load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
		vim.ui.input = function(...)
			lazy.load({ plugins = { "dressing.nvim" } })
			return vim.ui.input(...)
		end
	end,
}
