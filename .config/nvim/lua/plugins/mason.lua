return {
  {
    "mason-org/mason.nvim",
    ---@module 'mason'
    ---@type MasonSettings
    opts = {
      ensure_installed = {
        "astro-language-server",
        "bash-language-server",
        "css-lsp",
        "deno",
        "emmet-language-server",
        "graphql-language-service-cli",
        "html-lsp",
        "json-lsp",
        "oxfmt",
        "oxlint",
        "prettierd",
        "shellcheck",
        "shopify-cli",
      },
    },
  },
}
