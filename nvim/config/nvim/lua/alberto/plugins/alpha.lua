return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		-- Check http://patorjk.com/software/taag
		dashboard.section.header.val = {
			[[          _____                    _____                   _______                   _____                    _____                    _____          ]],
			[[         /\    \                  /\    \                 /::\    \                 /\    \                  /\    \                  /\    \         ]],
			[[        /::\____\                /::\    \               /::::\    \               /::\____\                /::\    \                /::\____\        ]],
			[[       /::::|   |               /::::\    \             /::::::\    \             /:::/    /                \:::\    \              /::::|   |        ]],
			[[      /:::::|   |              /::::::\    \           /::::::::\    \           /:::/    /                  \:::\    \            /:::::|   |        ]],
			[[     /::::::|   |             /:::/\:::\    \         /:::/~~\:::\    \         /:::/    /                    \:::\    \          /::::::|   |        ]],
			[[    /:::/|::|   |            /:::/__\:::\    \       /:::/    \:::\    \       /:::/____/                      \:::\    \        /:::/|::|   |        ]],
			[[   /:::/ |::|   |           /::::\   \:::\    \     /:::/    / \:::\    \      |::|    |                       /::::\    \      /:::/ |::|   |        ]],
			[[  /:::/  |::|   | _____    /::::::\   \:::\    \   /:::/____/   \:::\____\     |::|    |     _____    ____    /::::::\    \    /:::/  |::|___|______  ]],
			[[ /:::/   |::|   |/\    \  /:::/\:::\   \:::\    \ |:::|    |     |:::|    |    |::|    |    /\    \  /\   \  /:::/\:::\    \  /:::/   |::::::::\    \ ]],
			[[/:: /    |::|   /::\____\/:::/__\:::\   \:::\____\|:::|____|     |:::|    |    |::|    |   /::\____\/::\   \/:::/  \:::\____\/:::/    |:::::::::\____\]],
			[[\::/    /|::|  /:::/    /\:::\   \:::\   \::/    / \:::\    \   /:::/    /     |::|    |  /:::/    /\:::\  /:::/    \::/    /\::/    / ~~~~~/:::/    /]],
			[[ \/____/ |::| /:::/    /  \:::\   \:::\   \/____/   \:::\    \ /:::/    /      |::|    | /:::/    /  \:::\/:::/    / \/____/  \/____/      /:::/    / ]],
			[[         |::|/:::/    /    \:::\   \:::\    \        \:::\    /:::/    /       |::|____|/:::/    /    \::::::/    /                       /:::/    /  ]],
			[[         |::::::/    /      \:::\   \:::\____\        \:::\__/:::/    /        |:::::::::::/    /      \::::/____/                       /:::/    /   ]],
			[[         |:::::/    /        \:::\   \::/    /         \::::::::/    /         \::::::::::/____/        \:::\    \                      /:::/    /    ]],
			[[         |::::/    /          \:::\   \/____/           \::::::/    /           ~~~~~~~~~~               \:::\    \                    /:::/    /     ]],
			[[         /:::/    /            \:::\    \                \::::/    /                                      \:::\    \                  /:::/    /      ]],
			[[        /:::/    /              \:::\____\                \::/____/                                        \:::\____\                /:::/    /       ]],
			[[        \::/    /                \::/    /                 ~~                                               \::/    /                \::/    /        ]],
			[[         \/____/                  \/____/                                                                    \/____/                  \/____/         ]],
			[[                                                                                                                                                      ]],
			[[                                                                                                                                                      ]],
		}

		alpha.setup(dashboard.opts)
	end,
}
