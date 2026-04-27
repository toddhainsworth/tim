return {
  {
    "aktersnurra/no-clown-fiesta.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("no-clown-fiesta")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        hide_dotfiles = false,
      },
      window = {
        width = 35,
      },
    },
  },
}
