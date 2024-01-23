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
					null_ls.builtins.formatting.jq,
					null_ls.builtins.diagnostics.eslint_d,
				},
			})

			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		end,
	},
}
