local add = require("util").add

add({
  "EdenEast/nightfox.nvim",
})

require("nightfox").setup()
vim.cmd.colorscheme("carbonfox")

add({
  "saghen/blink.cmp",
  "rafamadriz/friendly-snippets",
})

require("blink.cmp").setup({
  keymap = { preset = "enter" },
})

add({
  "nvim-lualine/lualine.nvim",
  "nvim-tree/nvim-web-devicons",
})

require("lualine").setup({
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "|", right = "|" },
  },
})

add({
  "akinsho/bufferline.nvim",
  "nvim-tree/nvim-web-devicons",
})

require("bufferline").setup({
  options = {
    close_command = function(n)
      Snacks.bufdelete(n)
    end,
    always_show_bufferline = false,
    offsets = {
      {
        filetype = "snacks_layout_box",
      },
    },
  },
})

add({
  "MeanderingProgrammer/render-markdown.nvim",
  "nvim-treesitter/nvim-treesitter",
  "nvim-mini/mini.icons",
})

require("render-markdown").setup()
