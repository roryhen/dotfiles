return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'lspconfig'
    ---@class (partial) PartialLspConfig : lspconfig.Config
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        astro = {},
        tsc = {
          cmd = { "/opt/homebrew/bin/tsc", "--lsp", "--stdio" },
          ---@type lspconfig.settings.ts_ls
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
