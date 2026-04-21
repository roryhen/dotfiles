local add = require("util").add
local map = require("util").map

add({
  "MagicDuck/grug-far.nvim",
})

--cmd = "GrugFar",
require("grug-far").setup({ headerMaxWidth = 80 })

map("<leader>sr", function()
  local grug = require("grug-far")
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })
end, "Search and Replace", { "n", "v" })

add({
  "folke/flash.nvim",
})

require("flash").setup()

-- stylua: ignore start
map("s", function() require("flash").jump() end, "Flash", { "n", "x", "o" })
map("S", function() require("flash").treesitter() end, "Flash Treesitter", { "n", "o", "x" })
map("r", function() require("flash").remote() end, "Remote Flash", "o")
map("R", function() require("flash").treesitter_search() end, "Treesitter Search", { "o", "x" })
map("<c-s>", function() require("flash").toggle() end, "Toggle Flash Search", { "c" })
-- stylua: ignore end

add({
  "folke/trouble.nvim",
})

--cmd = "Trouble",
map("<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")
map("<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)")
map("<leader>xL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
map("<leader>xQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)")
