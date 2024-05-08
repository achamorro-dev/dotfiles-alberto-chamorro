return {
	{
		"nvimtools/none-ls.nvim",
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local mason_null_ls = require("mason-null-ls")

			mason_null_ls.setup({
				ensure_installed = { "stylua", "jq", "eslint_d", "prettier" },
			})

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
					require("none-ls.formatting.jq"),
					-- require("none-ls.code_actions.eslint"),
					require("none-ls.diagnostics.eslint_d").with({
						condition = function(utils)
							return utils.root_has_file({
								"eslint.config.js",
								".eslintrc",
								".eslintrc.js",
								".eslintrc.cjs",
								".eslintrc.yaml",
								".eslintrc.yml",
								".eslintrc.json",
							})
						end,
					}),
				},
			})

			vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, {})
		end,
	},
}
