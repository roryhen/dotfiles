return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    ---@module 'CopilotChat'
    ---@type CopilotChat.config.Config
    opts = {
      model = "claude-sonnet-4.6",
      window = {
        layout = "horizontal",
      },
      trusted_tools = { "file", "glob", "grep" },
      sticky = {
        "#selection",
        "#buffer:listed",
        "#gitdiff:unstaged",
        "#gitdiff:staged",
      },
    },
  },
}
