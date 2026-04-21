vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")

local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local plugin_files = vim.fn.globpath(plugins_dir, "*.lua", false, true)

for _, file in ipairs(plugin_files) do
  local plugin_name = vim.fn.fnamemodify(file, ":t:r")
  require("plugins." .. plugin_name)
end
