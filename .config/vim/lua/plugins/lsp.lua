return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        "mason-org/mason.nvim",
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "saghen/blink.cmp" },
    },
    lazy = false,
    opts = {
      servers = {
        astro = {},
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
        prettierd = {},
        shopify_theme_ls = {},
        sqlfluff = {},
        tailwindcss = {},
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
    config = function(_, opts)
      local function augroup(name, clear)
        if clear == nil then
          clear = true
        end
        return vim.api.nvim_create_augroup("user_" .. name, { clear = clear })
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup("lsp_attach"),
        callback = function(event)
          local function map(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("K", vim.lsp.buf.hover, "Hover Docs")
          map("<c-space>", vim.lsp.completion, "Completion Menu", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
          map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename")

          local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
          if client and client:supports_method("textDocument/documentHighlight", event.buf) then
            local highlight_augroup = augroup("lsp_highlight", false)
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = augroup("lsp-detach"),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "user_lsp_highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client:supports_method("textDocument/inlayHint", event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints")
          end
        end,
      })

      local ensure_installed = vim.tbl_keys(opts.servers or {})
      vim.list_extend(ensure_installed, {
        "bashls",
        "html",
        "jsonls",
        "js-debug-adapter",
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                version = "LuaJIT",
                path = { "lua/?.lua", "lua/?/init.lua" },
              },
              workspace = {
                checkThirdParty = false,
                -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                --  See https://github.com/neovim/nvim-lspconfig/issues/3189
                library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                }),
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },
        "marksman",
        "shellcheck",
        "shfmt",
        "stylua",
        "taplo",
        "yamlls",
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      for name, server in pairs(opts.servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}
