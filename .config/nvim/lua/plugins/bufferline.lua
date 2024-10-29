return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
    keys = {
      { "gb", "<cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
    },
  },
}
