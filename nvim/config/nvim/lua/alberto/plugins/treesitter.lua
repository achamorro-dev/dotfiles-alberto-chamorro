return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/playground",
		"nvim-treesitter/nvim-treesitter-refactor",
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			init = function()
				local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
				local opts = require("lazy.core.plugin").values(plugin, "opts", false)
				local enabled = false
				if opts.textobjects then
					for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
						if opts.textobjects[mod] and opts.textobjects[mod].enable then
							enabled = true
							break
						end
					end
				end
				if not enabled then
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
				end
			end,
		},
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
			ensure_installed = {
				"c",
				"cpp",
				"python",
				"lua",
				"typescript",
				"tsx",
				"regex",
				"bash",
				"cmake",
				"css",
				"javascript",
				"html",
				"comment",
				"java",
				"rust",
				"go",
				"markdown",
				"make",
				"json",
				"vim",
				"astro",
				"dart",
				"scss",
				"sql",
			},
			highlight = {
				enable = true,
			},
			auto_install = true,
			autotag = true,
			indent = {
				enable = true,
			},
			context_comment_string = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}
