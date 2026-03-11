return {
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.plugins.Config
    opts = {
      scratch = {
        win = {
          relative = "editor",
          style = "float",
        },
      },
      notifier = {
        top_down = false,
      },
    },
  },
}
