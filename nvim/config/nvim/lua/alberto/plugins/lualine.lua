return {
	"nvim-lualine/lualine.nvim",
	event = "BufRead",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	opts = function()
		local icons = require("alberto.util.icons")
		return {
			options = {
				icons_enabled = true,
				theme = "auto",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						color_error = "#BF616A",
						color_warn = "#EBCB8B",
						color_info = "#88C0D0",
						color_hint = "#3A4151",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = {
							left = 1,
							right = 0,
						},
					},
					{ "filename", path = 1, symbols = { modified = " ", readonly = "", unnamed = "" } },
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
		}
	end,
}
