return {
  { "mason-org/mason.nvim", opts = {} },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = function()
      local base = require("config.servers")
      local ok, extra = pcall(require, "config.servers_local")
      local servers = ok and vim.list_extend(vim.deepcopy(base), extra) or base
      return {
        ensure_installed = servers,
        -- Only auto-enable servers we explicitly manage
        automatic_enable = servers,
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
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
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end

          map("gd",          vim.lsp.buf.definition,                         "Go to definition")
          map("gD",          vim.lsp.buf.declaration,                        "Go to declaration")
          map("gr",          vim.lsp.buf.references,                         "References")
          map("gi",          vim.lsp.buf.implementation,                     "Go to implementation")
          map("K",           vim.lsp.buf.hover,                              "Hover docs")
          map("<leader>rn",  vim.lsp.buf.rename,                             "Rename symbol")
          map("<leader>ca",  vim.lsp.buf.code_action,                        "Code action")
          map("<leader>lf",  function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
        end,
      })
    end,
  },
}
