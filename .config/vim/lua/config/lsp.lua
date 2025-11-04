vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

local lsp_config = {
  astro = {},
  bashls = {},
  cssls = {},
  denols = {},
  docker_compose_language_service = {},
  dockerls = {},
  emmet_language_server = {},
  graphql = {},
  hadolint = {},
  html = {},
  ["js-debug-adapter"] = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
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
  vtsls = {
    root_dir = function(bufnr, on_dir)
      local root_markers = {
        { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
        { ".git" },
      }

      if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
        return
      end

      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

      on_dir(project_root)
    end,
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

local servers = vim.tbl_keys(lsp_config or {})

require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = servers,
})
require("mason-lspconfig").setup()
for server, config in pairs(lsp_config) do
  vim.lsp.config(server, config)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

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
  virtual_lines = {
    current_line = true,
  },
})
