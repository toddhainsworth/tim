return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>ng", "<cmd>Neogit<cr>" },
    },
    opts = {},
  },

  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>" },
    },
    opts = {},
  },
}
