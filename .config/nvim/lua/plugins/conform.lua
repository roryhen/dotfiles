return {
  {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        html = { "prettierd" },
        css = { "prettierd" },
        json = { "prettierd" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        liquid = { "prettierd" },
        astro = { "eslint_d" },
      },
    },
  },
}
