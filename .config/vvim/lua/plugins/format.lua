local add = require("util").add
local map = require("util").map

add({
  "tpope/vim-sleuth",
  "stevearc/conform.nvim",
})

-- You can use 'stop_after_first' to run the first available formatter from the list
local formatters = { "oxfmt", "deno_fmt", stop_after_first = true }

require("conform").setup({
  notify_on_error = false,
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    css = formatters,
    html = formatters,
    javascript = formatters,
    json = formatters,
    jsonc = formatters,
    jsx = formatters,
    markdown = formatters,
    tsx = formatters,
    typescript = formatters,
  },
})

map("<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, "Format buffer", "")
