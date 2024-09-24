local prettier = { "prettierd", "prettier" }
return {
  {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        html = prettier,
        css = prettier,
        json = prettier,
        javascript = prettier,
        typescript = prettier,
        liquid = prettier,
      },
    },
  },
}
