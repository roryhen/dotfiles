local formatters = { "oxfmt", "deno_fmt", stop_after_first = true }
local prettier_compat = {
  append_args = {
    "--print-width",
    "80",
    "--sort-tailwindcss",
    "true",
  },
}
return {
  {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      formatters = {
        typescript = prettier_compat,
        typescriptreact = prettier_compat,
      },
      formatters_by_ft = {
        astro = formatters,
        css = formatters,
        graphql = formatters,
        handlebars = formatters,
        html = formatters,
        javascript = formatters,
        javascriptreact = formatters,
        json = formatters,
        liquid = formatters,
        markdown = formatters,
        ["markdown.mdx"] = formatters,
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
