return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      "echasnovski/mini.icons",
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      float = {
        max_height = 50,
        preview_split = "above",
      },
    },
    keys = {
      { "<leader>o", "<cmd>Oil --float<CR>", desc = "Open parent directory" },
    },
  },
}
