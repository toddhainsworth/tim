-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Enable spell checking in Markdown buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_au"
  end,
})

-- Generate-commit-message keymap in commit buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "NeogitCommitMessage" },
  callback = function(ev)
    vim.keymap.set("n", "<leader>gm", function()
      require("tim.commit").generate()
    end, { buffer = ev.buf, desc = "Generate commit message" })
  end,
})
