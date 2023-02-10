local status_ok, flutter_tools = pcall(require, "flutter-tools")
if not status_ok then
	return
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local debugger_dir = vim.fn.stdpath("cache") .. "/dart-code"
local debugger_path = debugger_dir .. "/out/dist/debug.js"

local dap = require("dap")
dap.adapters.dart = {
	type = "executable",
	command = "node",
	args = { debugger_path, "flutter" },
}

flutter_tools.setup({
	debugger = {
		enabled = true,
		run_via_dap = true,
		register_configurations = function()
			-- local dap = require("dap")
			-- dap.adapters.dart = {
			-- 	type = "executable",
			-- 	command = "node",
			-- 	args = { debugger_path, "flutter" },
			-- }
			local dir = vim.fn.getcwd()
			if vim.fn.filereadable(dir .. "/.vscode/launch.json") ~= 0 then
				require("dap").configurations.dart = {}
				require("dap.ext.vscode").load_launchjs()
			end
		end,
	},
	fvm = true,
	decorations = {
		statusline = {
			device = true,
		},
	},
	dev_log = {
		enabled = true,
		open_cmd = "tabedit",
	},
	--[[ dev_tools = {
		autostart = true,
		auto_open_browser = true,
	}, ]]
	lsp = {
		color = {
			enabled = true,
			background = false,
			foreground = false,
			virtual_text = true,
			virtual_text_str = "■",
		},
		capabilities = capabilities,
	},
})
