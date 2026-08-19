local add = require("util").add
local map = require("util").map

add({
  "tpope/vim-sleuth",
  "stevearc/conform.nvim",
})

require("conform").setup({
  notify_on_error = false,
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    astro = { "deno_fmt" },
    css = { "deno_fmt" },
    html = { "deno_fmt" },
    javascript = { "deno_fmt" },
    javascriptreact = { "deno_fmt" },
    json = { "deno_fmt" },
    jsonc = { "deno_fmt" },
    lua = { "stylua" },
    markdown = { "deno_fmt" },
    typescript = { "deno_fmt" },
    typescriptreact = { "deno_fmt" },
  },
})

map("<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, "Format buffer", { "n", "i", "v" })
