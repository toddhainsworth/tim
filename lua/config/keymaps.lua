local map = vim.keymap.set

-- Editor
map("n", "<leader>n", "<cmd>nohlsearch<CR>")

-- Windows
map("n", "<leader>wq", "<C-w>h")
map("n", "<leader>ws", "<C-w>j")
map("n", "<leader>ww", "<C-w>k")
map("n", "<leader>we", "<C-w>l")

-- Buffers
map("n", "]b", "<cmd>bnext<cr>")
map("n", "[b", "<cmd>bprev<cr>")

-- Quickfix
map("n", "]q", "<cmd>cnext<cr>")
map("n", "[q", "<cmd>cprev<cr>")

-- Diagnostics
map("n", "gl", vim.diagnostic.open_float)
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
