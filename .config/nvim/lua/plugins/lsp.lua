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
          keys = {
            { "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
          },
        },
      },
    },
  },
}
