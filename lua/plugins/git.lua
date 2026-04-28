return {
  {
    "FabijanZulj/blame.nvim",
    keys = {
      { "<leader>gb", "<cmd>BlameToggle window<cr>" },
    },
    opts = {},
  },

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
