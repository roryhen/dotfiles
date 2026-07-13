return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'lspconfig'
    ---@class (partial) PartialLspConfig : lspconfig.Config
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        vtsls = {
          ---@type lspconfig.settings.vtsls
          settings = {
            typescript = {
              preferences = {
                useAliasesForRenames = false,
                preferTypeOnlyAutoImports = true,
              },
            },
          },
          keys = {
            { "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
          },
        },
      },
    },
  },
}
