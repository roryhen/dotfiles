return {
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      notifier = {
        top_down = false,
      },
      scratch = {
        win = {
          relative = "editor",
          style = "float",
        },
      },
    },
  },
}
