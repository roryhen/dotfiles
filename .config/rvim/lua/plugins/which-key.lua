local add = require("util").add
local map = require("util").map

add({
  "folke/which-key.nvim",
})

require("which-key").setup({
  preset = "helix",
  defaults = {},
  spec = {
    {
      mode = { "n", "v" },
      { "<leader><tab>", group = "tabs" },
      { "<leader>c", group = "code" },
      { "<leader>r", hidden = true },
      { "<leader>t", hidden = true },
      { "<leader>d", group = "debug" },
      { "<leader>dp", group = "profiler" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>q", group = "quit/session" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
      { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      -- stylua: ignore
      { "<leader>b", group = "buffer", expand = function() return require("which-key.extras").expand.buf() end, },
      -- stylua: ignore
      { "<leader>w", group = "windows", proxy = "<c-w>", expand = function() return require("which-key.extras") .expand.win() end, },
      -- better descriptions
      { "gx", desc = "Open with system app" },
    },
  },
})

--stylua: ignore start
map("<leader>?", function() require("which-key").show({ global = false }) end, "Buffer Keymaps (which-key)")
map("<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, "Window Hydra Mode (which-key)")
