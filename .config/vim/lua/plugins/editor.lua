return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    event = "VeryLazy",
    opts = {
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
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    event = "VeryLazy",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
