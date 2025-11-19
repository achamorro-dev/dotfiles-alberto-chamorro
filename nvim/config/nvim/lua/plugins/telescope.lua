return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
      desc = "Buffers",
    },
    { "<leader>fB", false },
    { "<leader>fc", false },
    { "<leader>ff", false },
    { "<leader>fF", false },
    { "<leader>fg", false },
    { "<leader>fr", false },
    { "<leader>fR", false },
    { "<leader>ft", false },

    { "<leader>f", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    -- { "<leader>e", "<cmd>Telescope buffers<cr>", desc = "Buffers (all)" },
    { "<leader>e", LazyVim.pick("buffers"), desc = "Buffers (all)" },
  },
}
