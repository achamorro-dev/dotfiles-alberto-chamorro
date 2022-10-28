local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local keymap = vim.keymap

local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "go", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "<F2>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("i", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
	keymap.set("n", "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", opts)
	keymap.set("v", "<Leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)
	keymap.set("n", "grn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
	end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = {
	{ name = "DiagnosticSignError", text = " " },
	{ name = "DiagnosticSignWarn", text = " " },
	{ name = "DiagnosticSignHint", text = " " },
	{ name = "DiagnosticSignInfo", text = " " },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
	-- disable virtual text
	virtual_text = true,
	-- show signs
	signs = {
		active = signs,
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
	width = 60,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
	width = 60,
})

-- local function lsp_keymaps(bufnr)
-- 	local opts = { noremap = true, silent = true }
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
-- 	vim.api.nvim_buf_set_keymap(
-- 		bufnr,
-- 		"n",
-- 		"gl",
-- 		'<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
-- 		opts
-- 	)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
-- 	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- 	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
-- end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure lua server (with special settings)
lspconfig["sumneko_lua"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
