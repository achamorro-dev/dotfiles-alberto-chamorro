return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		priority = 100,
		dependencies = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
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
					"make",
					"json",
					"vim",
					"astro",
					"dart",
					"scss",
					"sql",
					"markdown",
					"markdown_inline",
				},
				highlight = {
					enable = true,
					disable = {},
					additional_vim_regex_highlighting = true,
				},
				auto_install = true,
				indent = {
					enable = true,
				},
				context_comment_string = {
					enable = true,
					enable_autocmd = false,
				},
				autotag = {
					enable = true,
				},
			})
		end,
	},
}
