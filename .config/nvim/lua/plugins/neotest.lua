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
        ["neotest-jest"] = {
          isTestFile = function(file_path)
            return string.match(file_path, "%.test%.[jt]sx?$")
          end,
        },
        ---@module 'neotest-vitest'
        ---@type neotest.VitestOptions
        ["neotest-vitest"] = {
          vitestConfigFile = function()
            local attributes = require("lfs").attributes("src/widgets")
            if attributes and attributes.mode == "directory" then
              return "vite.widgets.config.ts"
            end
            return "vite.config.ts"
          end,
          is_test_file = function(file_path)
            return string.match(file_path, "%.(test|spec|vitest)%.[jt]sx?$")
          end,
        },
      },
    },
  },
}
