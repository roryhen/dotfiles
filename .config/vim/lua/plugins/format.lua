return {
  { -- sets tabstop and shiftwidth for you
    "tpope/vim-sleuth",
    lazy = true,
    event = "BufEnter",
  },
  { -- Autoformat
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufReadPre",
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
    config = function(_, opts)
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

      local defaults = {
        formatters_by_ft = {},
        notify_on_error = false,
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      }

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
        defaults.formatters_by_ft[filetype] = formatters_for_js
      end

      local options = vim.tbl_deep_extend("force", defaults, opts or {})
      require("conform").setup(options)
    end,
  },
}
