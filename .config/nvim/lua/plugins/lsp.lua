return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        emmet_ls = {
          filetypes = { "liquid" },
        },
      },
    },
  },
}
