local map = require("util").map

-- better up/down
map("j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }, { "n", "x" })
map("<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }, { "n", "x" })
map("k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }, { "n", "x" })
map("<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }, { "n", "x" })

-- Move to window using the <ctrl> hjkl keys
map("<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- buffers
map("<S-h>", "<cmd>bprevious<cr>", "Prev Buffer")
map("<S-l>", "<cmd>bnext<cr>", "Next Buffer")
map("[b", "<cmd>bprevious<cr>", "Prev Buffer")
map("]b", "<cmd>bnext<cr>", "Next Buffer")
map("<leader>bb", "<cmd>e #<cr>", "Switch to Other Buffer")
map("<leader>`", "<cmd>e #<cr>", "Switch to Other Buffer")
map("<leader>bD", "<cmd>:bd<cr>", "Delete Buffer and Window")

-- Clear search, diff update and redraw
map("<Esc>", "<cmd>nohlsearch<CR>", nil)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }, "x")
map("n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }, "o")
map("N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }, "x")
map("N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }, "o")

-- Add undo break-points
map(",", ",<c-g>u", nil, "i")
map(".", ".<c-g>u", nil, "i")
map(";", ";<c-g>u", nil, "i")

--keywordprg
map("<leader>K", "<cmd>norm! K<cr>", "Keywordprg")

-- better indenting
map("<", "<gv", nil, "v")
map(">", ">gv", nil, "v")

--vim.pack
map("<leader>p", function()
  vim.pack.update()
end, "Pack Update")

-- new file
map("<leader>fn", "<cmd>enew<cr>", "New File")

-- location list
map("<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, "Location List")

-- quickfix list
map("<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, "Quickfix List")

-- diagnostic
local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ severity = severity, count = next and 1 or -1 })
  end
end
map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
map("]d", diagnostic_goto(true), "Next Diagnostic")
map("[d", diagnostic_goto(false), "Prev Diagnostic")
map("]e", diagnostic_goto(true, "ERROR"), "Next Error")
map("[e", diagnostic_goto(false, "ERROR"), "Prev Error")
map("]w", diagnostic_goto(true, "WARN"), "Next Warning")
map("[w", diagnostic_goto(false, "WARN"), "Prev Warning")
-- highlights under cursor
map("<leader>ui", vim.show_pos, "Inspect Pos")
map("<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, "Inspect Tree")

-- windows
map("<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("<leader><tab>l", "<cmd>tablast<cr>", "Last Tab")
map("<leader><tab>o", "<cmd>tabonly<cr>", "Close Other Tabs")
map("<leader><tab>f", "<cmd>tabfirst<cr>", "First Tab")
map("<leader><tab><tab>", "<cmd>tabnew<cr>", "New Tab")
map("<leader><tab>]", "<cmd>tabnext<cr>", "Next Tab")
map("<leader><tab>d", "<cmd>tabclose<cr>", "Close Tab")
map("<leader><tab>[", "<cmd>tabprevious<cr>", "Previous Tab")
