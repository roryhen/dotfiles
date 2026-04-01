return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    ---@module 'CopilotChat'
    ---@type CopilotChat.config.Config
    opts = {
      model = "claude-sonnet-4.5",
      window = {
        layout = "horizontal",
      },
    },
  },
}
