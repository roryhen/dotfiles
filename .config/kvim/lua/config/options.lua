-- See `:help vim.o`
-- For more options, you can see `:help option-list`
local opt = vim.o

vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)
opt.breakindent = true
opt.confirm = true
opt.cursorline = true
opt.ignorecase = true
opt.inccommand = "split"
opt.list = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 20
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 250
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
