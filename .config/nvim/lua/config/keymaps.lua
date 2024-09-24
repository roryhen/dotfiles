local set = vim.keymap.set

-- Source nvim
set("n", "<leader>sv", "<cmd>luafile $MYVIMRC<cr>", { desc = "Source nvim config" })

-- Center cursor after jumping
set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })

-- Window resize
set("n", "<M-,>", "<c-w>5<", { desc = "Decrease window width" })
set("n", "<M-.>", "<c-w>5>", { desc = "Increase window width" })
set("n", "<M-t>", "<C-W>+", { desc = "Increase window height" })
set("n", "<M-s>", "<C-W>-", { desc = "Decrease window height" })
