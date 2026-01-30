return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<C-n>", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    },
  },

  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
}
