-- Keymaps aligned with VS Code keybindings.json
return {
  {
    "folke/snacks.nvim",
    keys = {
      -- VS Code: space space = command palette
      {
        "<leader><space>",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      -- VS Code: space f = go to file
      { "<leader>f", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- VS Code: space e = recent editors
      {
        "<leader>e",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      { "<leader>fB", false },
      { "<leader>fc", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fg", false },
      { "<leader>fr", false },
      { "<leader>fR", false },
      { "<leader>fp", false },
      -- VS Code: space g d = next change (git diff picker removed)
      { "<leader>gd", false },
      -- VS Code: space s = toggle terminal
      {
        "<leader>s",
        function()
          Snacks.terminal.focus(nil, { cwd = LazyVim.root() })
        end,
        mode = { "n", "t" },
        desc = "Terminal (Root Dir)",
      },

      -- Search group moved from <leader>s to <leader>l (VS Code: space l g = grep)
      { "<leader>sb", false },
      { "<leader>sB", false },
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sp", false },
      { "<leader>sw", false },
      { "<leader>sW", false },
      { '<leader>s"', false },
      { "<leader>s/", false },
      { "<leader>sa", false },
      { "<leader>sc", false },
      { "<leader>sC", false },
      { "<leader>sd", false },
      { "<leader>sD", false },
      { "<leader>sh", false },
      { "<leader>sH", false },
      { "<leader>si", false },
      { "<leader>sj", false },
      { "<leader>sk", false },
      { "<leader>sl", false },
      { "<leader>sM", false },
      { "<leader>sm", false },
      { "<leader>sR", false },
      { "<leader>sq", false },
      { "<leader>su", false },
      {
        "<leader>lb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>lB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
      },
      { "<leader>lg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>lG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      {
        "<leader>lp",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },
      { "<leader>lw", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      {
        "<leader>lW",
        LazyVim.pick("grep_word", { root = false }),
        desc = "Visual selection or word (cwd)",
        mode = { "n", "x" },
      },
      {
        '<leader>l"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>l/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>la",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        "<leader>lc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>lC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>ld",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>lD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>lh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>lH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>li",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>lj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>lk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>ll",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>lM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>lm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>lR",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>lq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>lu",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undotree",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>ss", false },
            { "<leader>sS", false },
            -- VS Code: g i / g t / g o
            {
              "gi",
              function()
                Snacks.picker.lsp_implementations()
              end,
              desc = "Goto Implementation",
              has = "implementation",
            },
            {
              "gt",
              function()
                Snacks.picker.lsp_type_definitions()
              end,
              desc = "Goto Type Definition",
              has = "typeDefinition",
            },
            {
              "go",
              function()
                Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter })
              end,
              desc = "Goto Symbol",
              has = "documentSymbol",
            },
            -- VS Code: space r n
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>l", group = "search" } } },
  },
  -- VS Code: space p = problems, space c s = trigger suggest
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>p", "<cmd>Trouble diagnostics toggle<cr>", desc = "Problems (Trouble)" },
      { "<leader>cs", false },
    },
  },
  {
    "saghen/blink.cmp",
    keys = {
      {
        "<leader>cs",
        function()
          require("blink.cmp").show()
        end,
        mode = { "n", "i" },
        desc = "Trigger Completion",
      },
    },
  },
  -- VS Code: space g d = next change, space g r = revert
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>gd",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Next Hunk",
      },
      { "<leader>gr", ":Gitsigns reset_hunk<CR>", mode = { "n", "x" }, desc = "Reset Hunk" },
    },
  },
  -- Noice group moved from <leader>sn to <leader>ln so <leader>s is instant
  {
    "folke/noice.nvim",
    keys = {
      { "<leader>sn", false },
      { "<leader>snl", false },
      { "<leader>snh", false },
      { "<leader>sna", false },
      { "<leader>snd", false },
      { "<leader>snt", false },
      { "<leader>ln", "", desc = "+noice" },
      {
        "<leader>lnl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>lnh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>lna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>lnd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<leader>lnt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker",
      },
    },
  },
  -- Search/replace moved from <leader>sr to <leader>lr
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>sr", false },
      {
        "<leader>lr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        desc = "Search and Replace",
      },
    },
  },
  -- Todos moved from <leader>st to <leader>lt
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>st", false },
      { "<leader>sT", false },
      {
        "<leader>lt",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
      {
        "<leader>lT",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}
