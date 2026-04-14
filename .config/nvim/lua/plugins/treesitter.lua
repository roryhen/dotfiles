return {
  {
    "nvim-treesitter/nvim-treesitter",
    ---@module 'nvim-treesitter'
    ---@class (partial) PartialTSConfig : TSConfig
    opts = {
      ensure_installed = {
        "liquid",
        "styled",
      },
    },
  },
}
