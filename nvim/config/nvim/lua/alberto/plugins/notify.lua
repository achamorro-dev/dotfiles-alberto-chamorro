return {
	"rcarriga/nvim-notify",
	opts = {
		timeout = 1500,
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
		top_down = false,
	},
	keys = {
		{
			"<leader>dn",
			function()
				require("notify").dismiss({ silent = true, pending = true })
			end,
			desc = "Delete all Notifications",
		},
	},
	init = function()
		-- when noice is not enabled, install notify on VeryLazy
		local Util = require("alberto.util")
		if not Util.has("noice.nvim") then
			Util.on_very_lazy(function()
				vim.notify = require("notify")
			end)
		end
	end,
}
