return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'lspconfig'
    ---@class (partial) PartialLspConfig : lspconfig.Config
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        astro = {},
        gh_actions_ls = {},
        tsc = {
          keys = {
            { "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
          },
        },
      },
    },
  },
}
