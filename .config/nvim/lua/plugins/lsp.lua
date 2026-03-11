return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'lspconfig'
    ---@type lspconfig.Config.command
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        --- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                useAliasesForRenames = false,
                preferTypeOnlyAutoImports = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "DrKJeff16/wezterm-types" },
    opts = {
      library = {
        -- Other library configs...
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
}
