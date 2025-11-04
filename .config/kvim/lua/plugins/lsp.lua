return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "saghen/blink.cmp" },
    },
    opts = {
      servers = {
        astro = {},
        bashls = {},
        denols = {
          root_dir = function()
            return require("lspconfig").util.root_pattern("deno.jsonc", "deno.json")
          end,
        },
        docker_compose_language_service = {},
        dockerls = {},
        emmet_language_server = {
          filetypes = { "liquid" },
        },
        eslint_d = {},
        ["eslint-lsp"] = {},
        graphql = {},
        hadolint = {},
        html = {},
        ["js-debug-adapter"] = {},
        jsonls = {},
        lua_ls = {},
        marksman = {},
        prettierd = {},
        shellcheck = {},
        shfmt = {},
        shopify_theme_ls = {},
        sqlfluff = {},
        stylua = {},
        tailwindcss = {},
        taplo = {},
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
        yamlls = {},
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(args)
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = args.buf, desc = "LSP: Rename" })
          vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, { buffer = args.buf, desc = "LSP: Goto Code Action" })
          vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "LSP: Goto Declaration" })

          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

          -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
          end

          -- Auto-format ("lint") on save.
          -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
          if not client:supports_method("textDocument/willSaveWaitUntil") and client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
        },
      })

      ---@type MasonLspconfigSettings
      require("mason-lspconfig").setup({
        automatic_enable = vim.tbl_keys(opts.servers or {}),
      })

      local ensure_installed = vim.tbl_keys(opts.servers or {})

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      for server_name, config in pairs(opts.servers) do
        vim.lsp.config(server_name, config)
      end
    end,
  },
}
