local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure null_ls
null_ls.setup({
	sources = {
		--  to disable file types use
		--  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
		formatting.prettier, -- js/ts formatter
		formatting.stylua, -- lua formatter
		diagnostics.eslint_d.with({ -- js/ts linter
			-- only enable eslint if root has .eslintrc.js
			condition = function(utils)
				return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
			end,
		}),
	},
})
