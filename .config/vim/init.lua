vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

-- 2. Bootstrap pack.nvim using Neovim's native vim.pack
vim.pack.add({ { src = "https://github.com/igmrrf/pack.nvim", branch = "main" } })
vim.cmd.packadd("pack.nvim")

-- 3. Initialize pack.nvim
require("pack").setup({
  ui = {
    border = "rounded",
    auto_open = true,
  },
  plugins = {
    { "igmrrf/pack.nvim" }, -- Let pack.nvim manage itself
    { import = "plugins" }, -- Import your plugin specs from lua/plugins/
  },
})

require("config.options")
require("config.keymaps")
require("config.autocmds")
