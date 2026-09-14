return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<leader>ao",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Sidekick Toggle OpenCode",
      },
      {
        "<leader>ai",
        function()
          require("sidekick.cli").toggle({ name = "pi", focus = true })
        end,
        desc = "Sidekick Toggle Pi",
      },
    },
  },
}
