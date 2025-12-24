return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'lspconfig'
    ---@type lspconfig.Config.command
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        denols = {
          enabled = true,
          root_dir = function()
            return require("lspconfig").util.root_pattern({ "deno.json", "deno.jsonc", "deno.lock" })
          end,
        },
        emmet_language_server = {},
        --- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
        vtsls = {
          settings = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
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
}
