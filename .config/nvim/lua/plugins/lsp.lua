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
          filetypes = { "typescript", "typescriptreact" },
          root_dir = require("lspconfig").util.root_pattern("deno.jsonc", "deno.json"),
        },
        vtsls = {
          settings = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            typescript = {
              preferences = {
                importModuleSpecifierPreference = "relative",
                useAliasesForRenames = false,
                preferTypeOnlyAutoImports = true,
              },
            },
          },
        },
      },
    },
  },
}
