local status_ok, _ = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

-- include treesitter and its config
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
		additional_vim_regex_highlighting = true,
	},
	auto_install = true,

	autotag = {
		enable = true,
	},
	context_comment_string = {
		enable = true,
		enable_autocmd = false,
	},
})
