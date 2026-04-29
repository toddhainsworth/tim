return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      diagnostics_buffer = {
        mode = "diagnostics",
        filter = { buf = 0 },
      },
    },
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics_buffer toggle<cr>", desc = "Buffer diagnostics" },
    {
      "]d",
      function()
        require("trouble").next({ mode = "diagnostics_buffer", skip_groups = true, jump = true })
      end,
    },
    {
      "[d",
      function()
        require("trouble").prev({ mode = "diagnostics_buffer", skip_groups = true, jump = true })
      end,
    },
  },
}
