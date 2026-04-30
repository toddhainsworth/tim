return {
  { "williamboman/mason.nvim", opts = {} },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "ts_ls", "yamlls", "marksman" },
      -- Only auto-enable servers we explicitly manage
      automatic_enable = { "ts_ls", "yamlls", "marksman" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      vim.diagnostic.config({
        underline = true,
        virtual_text = false,
        signs = false,
        float = {
          border = "rounded",
          source = true,
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func)
            vim.keymap.set("n", keys, func, { buffer = event.buf })
          end

          map("gd", vim.lsp.buf.definition)
          map("gD", vim.lsp.buf.declaration)
          map("gr", vim.lsp.buf.references)
          map("gi", vim.lsp.buf.implementation)
          map("K", vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("<leader>f", function() vim.lsp.buf.format({ async = true }) end)
        end,
      })
    end,
  },
}
