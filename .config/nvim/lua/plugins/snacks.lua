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
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = {
            hidden = true,
            layout = {
              preview = {
                main = true,
                enabled = false,
              },
            },
          },
        },
      },
    },
  },
}
