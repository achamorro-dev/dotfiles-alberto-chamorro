return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  branch = "v2.x",
  keys = {
    { "<leader>t", "<cmd>Neotree toggle<CR>", desc = "Neotree" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<Tab>"] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
        },
        follow_current_file = true,
        group_empty_dirs = false,
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            --auto close
            require("neo-tree").close_all()
          end,
        },
      },
    })
  end,
}
