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
					"dart-debug-adapter",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"pmizio/typescript-tools.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local typescript = require("typescript-tools")
			lspconfig.lua_ls.setup({})

			-- lspconfig.tsserver.setup({})
			typescript.setup({
				settings = {
					-- spawn additional tsserver instance to calculate diagnostics on it
					separate_diagnostic_server = true,
					-- "change"|"insert_leave" determine when the client asks the server about diagnostic
					publish_diagnostic_on = "insert_leave",
					-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
					-- "remove_unused_imports"|"organize_imports") -- or string "all"
					-- to include all supported code actions
					-- specify commands exposed as code_actions
					expose_as_code_action = { "all" },
					-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
					-- not exists then standard path resolution strategy is applied
					tsserver_path = nil,
					-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
					-- (see 💅 `styled-components` support section)
					tsserver_plugins = {},
					-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
					-- memory limit in megabytes or "auto"(basically no limit)
					tsserver_max_memory = "auto",
					-- described below
					tsserver_format_options = {},
					tsserver_file_preferences = {},
					-- locale of all tsserver messages, supported locales you can find here:
					-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
					tsserver_locale = "en",
					-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
					complete_function_calls = false,
					include_completions_with_insert_text = true,
					-- CodeLens
					-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
					-- possible values: ("off"|"all"|"implementations_only"|"references_only")
					code_lens = "off",
					-- by default code lenses are displayed on all referencable values and for some of you it can
					-- be too much this option reduce count of them by removing member references from lenses
					disable_member_code_lens = true,
					-- JSXCloseTag
					-- that maybe have a conflict if enable this feature. )
					-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
					jsx_close_tag = {
						enable = false,
						filetypes = { "javascriptreact", "typescriptreact" },
					},
				},
			})

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set("n", "<F8>", vim.diagnostic.goto_next)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
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
					keymap.set("n", "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", opts)
					keymap.set("v", "<Leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)
					keymap.set("n", "grn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename

					-- format on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
						buffer = ev.buf,
						callback = function()
							vim.lsp.buf.format()
						end,
					})
				end,
			})
		end,
	},
}
