return {
	-- add typescript to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
			end
		end,
	},

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = { "jose-elias-alvarez/typescript.nvim" },
		opts = {
			-- make sure mason installs the server
			servers = {
				---@type lspconfig.options.tsserver
				tsserver = {
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				},
			},
			setup = {
				tsserver = function(_, opts)
					vim.api.nvim_create_autocmd("BufWritePre", {
						callback = function(event)
							if require("lspconfig.util").get_active_client_by_name(event.buf, "tsserver") then
								vim.cmd("TypescriptRemoveUnused")
							end
						end,
					})
					require("alberto.util").on_attach(function(client, buffer)
						if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>oi", "<cmd>TypescriptOrganizeImports<CR>",
                { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>rf", "<cmd>TypescriptRenameFile<CR>",
                { desc = "Rename File", buffer = buffer })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>ru", "<cmd>TypescriptRemoveUnused<CR>",
                { buffer = buffer, desc = "Remove unused imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>am", "<cmd>TypescriptAddMissingImports<CR>",
                { buffer = buffer, desc = "Add missing imports" })
						end
					end)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
		end,
	},
}
