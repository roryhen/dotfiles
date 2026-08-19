return {
  { -- sets tabstop and shiftwidth for you
    "tpope/vim-sleuth",
    event = "VeryLazy",
  },
  { -- Autoformat
    "stevearc/conform.nvim",
    event = "VeryLazy",
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
    opts = function(_, opts)
      local function formatters_for_js(bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local directory = vim.fs.dirname(filename)

        local deno_config = vim.fs.find({
          "deno.json",
          "deno.jsonc",
          "deno.lock",
        }, {
          path = directory,
          upward = true,
          type = "file",
        })

        if #deno_config > 0 then
          return { "deno_fmt" }
        end

        return { "prettierd" }
      end

      opts.formatters_by_ft = opts.formatters_by_ft or {}

      for _, filetype in ipairs({
        "astro",
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "liquid",
        "markdown",
        "markdown.mdx",
        "svelte",
        "typescript",
        "typescriptreact",
        "vue",
        "yaml",
        "toml",
      }) do
        opts.formatters_by_ft[filetype] = formatters_for_js
      end

      opts.notify_on_error = false
      opts.format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      }
    end,
  },
}
