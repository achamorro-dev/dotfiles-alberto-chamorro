local filetype_attach = setmetatable({}, {
	__index = function()
		return function() end
	end,
})

return function(client, bufnr)
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local keymap = vim.keymap
	local opts = { noremap = true, silent = true, buffer = bufnr }

	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "go", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- see outline on right hand side
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "<F2>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("i", "<C-s>", "<Cmd>Lspsaga signature_help<CR>", opts)
	keymap.set("n", "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", opts)
	keymap.set("v", "<Leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", opts)
	keymap.set("n", "grn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
		keymap.set("n", "<leader>am", ":TypescriptAddMissingImports<CR>")
	end

	-- format on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
		buffer = bufnr,
		callback = function()
        -- require("notify")(client.name)
			if client.name == "tsserver" then
				local typescript = require("typescript")
				typescript.actions.removeUnused({ sync = true })
				typescript.actions.organizeImports({ sync = true })
			end
			vim.lsp.buf.format()
		end,
	})

	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Attach any filetype specific options to the client
	filetype_attach[filetype](client, bufnr)
end
