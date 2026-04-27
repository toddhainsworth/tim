return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>fs", "<cmd>Telescope aerial<cr>" },
    },
    config = function()
      require("aerial").setup({
        backends = { "treesitter", "lsp" },
        show_guides = false,
        layout = { default_direction = "prefer_right" },
        attach_mode = "global",
      })
      require("telescope").load_extension("aerial")
    end,
  },
}
