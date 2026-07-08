local formatters = { "oxfmt", "prettierd", stop_after_first = true }
return {
  {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        css = formatters,
        graphql = formatters,
        handlebars = formatters,
        html = formatters,
        javascript = formatters,
        javascriptreact = formatters,
        json = formatters,
        liquid = formatters,
        markdown = formatters,
        markdown_mdx = formatters,
        scss = formatters,
        svelte = formatters,
        typescript = formatters,
        typescriptreact = formatters,
        vue = formatters,
        yaml = formatters,
        toml = formatters,
      },
    },
  },
}
