return {
	-- add typescript to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "java", "kotlin" })
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mfussenegger/nvim-jdtls",
				config = function()
					local config = {
						cmd = { vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin/jdtls" },
						root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
					}
					require("jdtls").start_or_attach(config)
				end,
			},
		},
		opts = {
			servers = {
				jdtls = {},
			},
			setup = {
				cmd = { "jdtls" },
			},
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			table.insert(opts.sources, require("null-ls").builtins.diagnostics.ktlint)
			table.insert(opts.sources, require("null-ls").builtins.formatting.ktlint)
		end,
	},
}
