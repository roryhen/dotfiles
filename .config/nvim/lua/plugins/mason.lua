return {
  {
    "mason-org/mason.nvim",
    ---@module 'mason'
    ---@type MasonSettings
    opts = {
      ensure_installed = {
        "shopify-cli",
        "css-lsp",
        "emmet-language-server",
      },
    },
  },
}
