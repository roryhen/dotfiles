return {
  {
    "nvim-neotest/neotest",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    ---@module 'neotest'
    ---@class (partial) PartialNTConfig : neotest.Config
    opts = {
      adapters = {
        ---@module 'neotest-jest'
        ---@type neotest.JestOptions
        "neotest-jest",
        ---@module 'neotest-vitest'
        ---@type neotest.VitestOptions
        ["neotest-vitest"] = {},
      },
    },
  },
}
