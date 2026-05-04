local M = {}

function M.setup()
  vim.api.nvim_set_hl(0, "TimTabActive",   { link = "Title",   default = true })
  vim.api.nvim_set_hl(0, "TimTabInactive", { link = "Comment", default = true })
  vim.api.nvim_set_hl(0, "TimTagHeader",   { link = "Title",   default = true })
end

return M
