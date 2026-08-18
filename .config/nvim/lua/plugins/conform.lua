return {
  {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type function|conform.setupOpts
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
    end,
  },
}
