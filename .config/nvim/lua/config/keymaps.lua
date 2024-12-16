local set = vim.keymap.set

-- Source nvim
set("n", "<leader>sv", "<cmd>luafile $MYVIMRC<cr>", { desc = "Source nvim config" })
