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
