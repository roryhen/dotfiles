local M = {}

---Add GitHub packages to vim.pack
---@param list string[] List of GitHub repository paths
M.add = function(list)
  local packs = {}
  local prefix = "https://github.com/"
  for _, source in ipairs(list) do
    table.insert(packs, prefix .. source)
  end
  vim.pack.add(packs)
end

---Set a keymap with optional description
---@param keys string Key sequence
---@param func function|string Function or command string
---@param desc nil|string|vim.keymap.set.Opts Description or options table
---@param mode? string|string[] Vim mode. Defaults to "n"
M.map = function(keys, func, desc, mode)
  mode = mode or "n"
  local opts = desc
  if type(desc) == "string" then
    opts = { desc = desc }
  end
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.keymap.set(mode, keys, func, opts)
end

---Create an autocommand group with event handlers
---@param event string|string[] Autocmd event(s)
---@param opts vim.api.keyset.create_autocmd Autocmd options with 'group' and 'callback'
---@param clear? boolean Clear group on creation. Defaults to true
M.autocmd = function(event, opts, clear)
  clear = clear or true
  opts.group = vim.api.nvim_create_augroup("user_" .. opts.group, { clear = clear })
  vim.api.nvim_create_autocmd(event, opts)
end

return M
