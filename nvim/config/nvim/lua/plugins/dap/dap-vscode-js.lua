local status_ok, dap_vscode_js = pcall(require, "dap-vscode-js")
if not status_ok then
	return
end

require("dap-vscode-js").setup({
	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
	debugger_cmd = { "js-debug-adapter" },
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
	-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
	-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

local dap = require("dap")
dap.adapters.typescript = dap.adapters["pwa-node"]

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
		{
			name = "Attach to node process",
			type = "pwa-node",
			request = "attach",
			rootPath = "${workspaceFolder}",
			processId = require("dap.utils").pick_process,
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch typescript file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			skipFiles = {
				"<node_internals>/**",
			},
			preLaunchTask = "tsc: build - tsconfig.json",
			outFiles = {
				"${workspaceFolder}/dist/**/*.js",
			},
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			sourceMaps = true,
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
	}
end

for _, language in ipairs({ "typescriptreact", "javascriptreact" }) do
	dap.configurations[language] = {
		{
			type = "pwa-chrome",
			name = "Attach - Remote Debugging",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			name = "Launch Chrome",
			request = "launch",
			url = "http://localhost:3000",
		},
	}
end

local dir = vim.fn.getcwd()
if vim.fn.filereadable(dir .. "/.vscode/launch.json") ~= 0 then
	require("dap.ext.vscode").load_launchjs()
end
