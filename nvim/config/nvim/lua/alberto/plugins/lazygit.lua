local Util = require("alberto.util")

return {
	"kdheepak/lazygit.nvim",
	cmd = "Lazygit",
	keys = {
		{
			"<C-g>",
			function()
				Util.float_term({ "lazygit" })
			end,
			desc = "Lazygit",
		},
	},
}
