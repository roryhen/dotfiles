vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("tabline", {}),
  desc = "tabline",
  callback = function()
    vim.opt.showtabline = 2
  end,
})
