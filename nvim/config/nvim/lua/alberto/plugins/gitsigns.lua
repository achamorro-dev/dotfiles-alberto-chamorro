return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	config = function()
		local gitsigns = require("gitsigns")
		local signs_icons = require("alberto.util.icons").signs
		gitsigns.setup({
			signs = {
				add = { text = signs_icons.add },
				change = { text = signs_icons.change },
				delete = { text = signs_icons.delete },
				topdelete = { text = signs_icons.topdelete },
				changedelete = { text = signs_icons.changedelete },
				untracked = { text = signs_icons.untracked },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "gh", gs.next_hunk, "Next Hunk")
        map("n", "gH", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "ghd", gs.diffthis, "Diff This")
        map("n", "ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		})
	end,
}
