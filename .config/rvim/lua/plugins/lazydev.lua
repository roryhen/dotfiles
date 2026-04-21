local add = require("util").add
local autocmd = require("util").autocmd

add({ "folke/lazydev.nvim" })

autocmd("FileType", {
  group = "lazydev_setup",
  pattern = { "lua" },
  callback = function()
    require("lazydev").setup({
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    })
  end,
})
