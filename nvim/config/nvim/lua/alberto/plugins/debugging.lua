local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
	"astro",
}

---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)

	---@cast args string[]
	config.args = function()
		---@diagnostic disable-next-line: redundant-parameter
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end

	return config
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "stevearc/overseer.nvim", opts = { dap = false } },
			{
				"rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",        mode = { "n", "v" } },
          { "<leader>dq", function() require("dapui").close() end,    desc = "Close Dap UI" },
        },
				opts = {},
			},
			{
				"Joakker/lua-json5",
				build = "./install.sh",
			},
			-- vscode-js-debug adapter
			{
				"microsoft/vscode-js-debug",
				build = "npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				opts = {
					debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
					-- debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'),
					adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node", "node-terminal", "pwa-extensionHost" },
				},
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
				config = function()
					require("nvim-dap-virtual-text").setup()
					vim.g.dap_virtual_text = true
				end,
			},
		},
    -- stylua: ignore
    keys = {
      { "<leader>dc", function() require("dap").continue() end,          desc = "Continue", },
      { "<leader>do", function() require("dap").step_over() end,         desc = "Step Over", },
      { "<leader>dO", function() require("dap").step_out() end,          desc = "Step Out", },
      { "<leader>di", function() require("dap").step_into() end,         desc = "Step Into", },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint", },
      {
        "<leader>ds",
        function()
          if vim.fn.filereadable('.vscode/launch.json') then
            local dap_vscode = require('dap.ext.vscode')
            dap_vscode.json_decode = require('overseer.json').decode
            dap_vscode.load_launchjs(nil, {
              ['chrome'] = js_based_languages,
              ['node'] = js_based_languages,
              ['pwa-node'] = js_based_languages,
              ['pwa-chrome'] = js_based_languages,
              ['node-terminal'] = js_based_languages,
            })
          end
          require('dap').continue()
        end,
        desc = "Run with Args",
      },
    },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			local icons = {
				Stopped = { " ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
			}

			for name, sign in pairs(icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			-- Use overseer for running preLaunchTask and postDebugTask.
			require("overseer").patch_dap(true)

			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					-- Debug single nodejs files
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						-- cwd = vim.fn.getcwd(),
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					-- Debug nodejs processes (make sure to add --inspect when you run the process)
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						-- cwd = vim.fn.getcwd(),
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						runtimeExecutable = "node",
						runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest", "--runInBand" },
						rootPath = "${workspaceFolder}",
						-- cwd = vim.fn.getcwd(),
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
						-- args = {'${file}', '--coverage', 'false'},
						-- sourceMaps = true,
						-- skipFiles = {'<node_internals>/**', 'node_modules/**'},
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Vitest Tests",
						cwd = vim.fn.getcwd(),
						program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
						args = { "run", "${file}" },
						autoAttachChildProcesses = true,
						smartStep = true,
						skipFiles = { "<node_internals>/**", "node_modules/**" },
					},
					-- Debug web applications (client side)
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch & Debug Chrome",
						url = function()
							local co = coroutine.running()
							return coroutine.create(function()
								vim.ui.input(
									{ prompt = "Enter URL: ", default = "http://localhost:3000" },
									function(url)
										if url == nil or url == "" then
											return
										else
											coroutine.resume(co, url)
										end
									end
								)
							end)
						end,
						webRoot = vim.fn.getcwd(),
						protocol = "inspector",
						sourceMaps = true,
						userDataDir = false,
					},
					-- Divider for the launch.json derived configs
					{
						name = "----- ↓ launch.json configs (if available) ↓ -----",
						type = "",
						request = "launch",
					},
				}
			end

			dap.adapters.node = {
				type = "executable",
				command = "node",
				args = { vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug") },
			}

			dap.adapters.chrome = {
				type = "executable",
				command = "node",
				args = { vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug") },
			}
		end,
	},
}
