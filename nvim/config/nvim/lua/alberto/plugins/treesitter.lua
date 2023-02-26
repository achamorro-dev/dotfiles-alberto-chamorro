return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/playground",
		"nvim-treesitter/nvim-treesitter-refactor",
		"nvim-treesitter/nvim-treesitter-textobjects",
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
				disable = {},
				additional_vim_regex_highlighting = false,
			},
			auto_install = true,
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
