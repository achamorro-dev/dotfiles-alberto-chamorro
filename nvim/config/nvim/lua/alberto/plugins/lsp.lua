return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "jose-elias-alvarez/null-ls.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "glepnir/lspsaga.nvim",
    "jose-elias-alvarez/typescript.nvim",
    "ThePrimeagen/refactoring.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "lewis6991/gitsigns.nvim",
    {
      "j-hui/fidget.nvim",
      opts = {
        sources = {
          ["null-ls"] = {
            ignore = true,
          },
        },
      },
    },
  },
  config = function()
    require("alberto.config.lsp")
  end,
}
