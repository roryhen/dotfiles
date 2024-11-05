return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        emmet_ls = {
          filetypes = { "liquid" },
        },
        eslint = {
          root_dir = require("lspconfig").util.root_pattern("eslint.config.js"),
          settings = {
            experimental = {
              useFlatConfig = true,
            },
          },
        },
        denols = {
          root_dir = require("lspconfig").util.root_pattern("deno.json"),
        },
      },
    },
  },
}
