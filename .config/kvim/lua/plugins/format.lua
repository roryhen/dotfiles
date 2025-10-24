local prettier_and_friends = { "prettierd", "prettier", "deno_fmt", stop_after_first = true }

return {
  { "tpope/vim-sleuth" }, -- sets tabstop and shiftwidth for you
  {                       -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = "never"
        else
          lsp_format_opt = "fallback"
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        css = prettier_and_friends,
        html = prettier_and_friends,
        javascript = prettier_and_friends,
        json = prettier_and_friends,
        jsonc = prettier_and_friends,
        jsx = prettier_and_friends,
        markdown = prettier_and_friends,
        tsx = prettier_and_friends,
        typescript = prettier_and_friends,
      },
    },
  },
}
