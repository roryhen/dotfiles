local add = require("util").add
local map = require("util").map
local autocmd = require("util").autocmd

add({
  "neovim/nvim-lspconfig",
  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "j-hui/fidget.nvim",
  "saghen/blink.cmp",
})

require("mason").setup()
require("fidget").setup()

autocmd("LspAttach", {
  group = "lsp_attach",
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    if client then
      if client:supports_method("textDocument/rename", event.buf) then
        map("<leader>cr", vim.lsp.buf.rename, "Rename")
      end

      if client:supports_method("textDocument/codeAction", event.buf) then
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
      end

      if client:supports_method("textDocument/codeLens") then
        map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
      end

      if client:supports_method("textDocument/documentHighlight", event.buf) then
        autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = "lsp_highlight",
          callback = vim.lsp.buf.document_highlight,
        }, false)

        autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = "lsp_highlight",
          callback = vim.lsp.buf.clear_references,
        }, false)

        autocmd("LspDetach", {
          group = "lsp-detach",
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "user_lsp_highlight", buffer = event2.buf })
          end,
        })
      end

      if client:supports_method("textDocument/inlayHint", event.buf) then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "Toggle Inlay Hints")
      end
    end
  end,
})

---@type table<string, vim.lsp.Config>
local all_servers = {
  astro = {},
  bashls = {},
  denols = {},
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
  jsonls = {},
  ["js-debug-adapter"] = {},
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
  marksman = {},
  prettierd = {},
  shellcheck = {},
  shfmt = {},
  shopify_theme_ls = {},
  sqlfluff = {},
  stylua = {},
  tailwindcss = {},
  taplo = {},
  tsgo = {
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
}

require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(all_servers) })

for name, server in pairs(all_servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

map("<leader>cm", "<cmd>Mason<cr>", "Mason")
