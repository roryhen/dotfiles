return {
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type function|snacks.plugins.Config
    opts = function(_, opts)
      opts.scratch = {
        win = {
          relative = "editor",
          style = "float",
        },
      }
      opts.notifier = {
        top_down = false,
      }
      opts.picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = {
            hidden = true,
            layout = {
              preview = "main",
              hidden = { "preview" },
            },
          },
        },
      }

      Snacks.util.set_hl({
        SnacksPickerGitStatusUntracked = { link = "Special" },
      })

      return opts
    end,
  },
}
