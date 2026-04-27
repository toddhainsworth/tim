local map = vim.keymap.set

-- Clear search highlight
map("n", "<leader>n", "<cmd>nohlsearch<CR>")

-- Diagnostics
map("n", "gl", vim.diagnostic.open_float)
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)

-- Window navigation
map("n", "<leader>wq", "<C-w>h")
map("n", "<leader>ws", "<C-w>j")
map("n", "<leader>ww", "<C-w>k")
map("n", "<leader>we", "<C-w>l")

