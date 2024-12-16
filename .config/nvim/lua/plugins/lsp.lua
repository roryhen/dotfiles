return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'lspconfig'
    ---@type lspconfig.Config.command
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        emmet_ls = {
          filetypes = { "liquid" },
        },
        denols = {
          root_dir = require("lspconfig").util.root_pattern("deno.json"),
        },
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifierPreference = "relative",
              },
            },
          },
        },
      },
    },
  },
}
