return {
  {
    "mason-org/mason.nvim",
    ---@module 'mason'
    ---@type MasonSettings
    opts = {
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
      ensure_installed = {
        "astro-language-server",
        "bash-language-server",
        "copilot-language-server",
        "css-lsp",
        "emmet-language-server",
        "graphql-language-service-cli",
        "html-lsp",
        "json-lsp",
        "prettierd",
        "shellcheck",
        "tree-sitter-cli",
      },
    },
  },
}
