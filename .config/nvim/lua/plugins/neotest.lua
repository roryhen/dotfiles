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
    ---@type neotest.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      adapters = {
        ["neotest-jest"] = {},
        ["neotest-vitest"] = {
          vitestCommand = function(file_path)
            if string.find(file_path, "/mktp-ui-widgets/") then
              return "npm run test:unit:widgets"
            end
          end,
          is_test_file = function(file_path)
            if string.match(file_path, ".vitest.ts") then
              return true
            end
          end,
        },
      },
    },
  },
}
