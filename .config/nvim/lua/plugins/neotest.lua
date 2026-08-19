return {
  {
    "nvim-neotest/neotest",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
    },
    ---@module 'neotest'
    ---@class (partial) PartialNTConfig : neotest.Config
    opts = {
      adapters = {
        ---@module 'neotest-vitest'
        ---@type neotest.VitestOptions
        ["neotest-vitest"] = {},
      },
    },
  },
}
