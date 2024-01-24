return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({
				finder = {
					default = "imp+ref",
					max_height = 0.6,
					keys = {
						toggle_or_open = "<Enter>",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"angularls",
					"astro",
					"bashls",
					"cssls",
					"cssmodules_ls",
					"dockerls",
					"dotls",
					"eslint",
					"emmet_ls",
					"html",
					"jdtls",
					"jsonls",
					"marksman",
					"kotlin_language_server",
					"rust_analyzer",
					"lua_ls",
					"svelte",
					"tsserver",
					"tailwindcss",
					"vuels",
					"yamlls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			{
				"ThePrimeagen/refactoring.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-treesitter/nvim-treesitter",
				},
				config = function()
					require("refactoring").setup()

					vim.keymap.set({ "n", "x" }, "<leader>rr", function()
						require("refactoring").select_refactor()
					end)
				end,
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			local typescript = require("typescript")
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local on_attach = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				local keymap = vim.keymap
				keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- show definition, references
				keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
				keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
				keymap.set("n", "gi", "<cmd>Lspsaga goto_definition<CR>", opts) -- go to implementation
				keymap.set("n", "go", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- see outline on right hand side
				keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
				keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
				keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
				keymap.set("i", "<C-s>", "<Cmd>Lspsaga signature_help<CR>", opts)
				keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
				keymap.set("n", "grn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename

				-- typescript specific keymaps (e.g. rename file and update imports)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client.name == "tsserver" then
					keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
					keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
					keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
					keymap.set("n", "<leader>am", ":TypescriptAddMissingImports<CR>")
				end

				-- format on save
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
					buffer = ev.buf,
					callback = function()
						vim.lsp.buf.format()
					end,
				})
			end

			-- Setups
			lspconfig.lua_ls.setup({})
			-- lspconfig.tsserver.setup({})
			typescript.setup({
				server = {
					capabilities = capabilities,
					on_attach = on_attach,
				},
			})

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set("n", "<F8>", vim.diagnostic.goto_next)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = on_attach,
			})
		end,
	},
}
