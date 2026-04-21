local add = require("util").add
local map = require("util").map

-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

add({
  "folke/snacks.nvim",
})

require("snacks").setup({
  explorer = { enabled = true },
  indent = { enabled = true },
  notifier = { enabled = true },
  picker = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = {
    win = {
      keys = {
        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
      },
    },
  },
  words = { enabled = true },
})

--stylua: ignore start
-- buffers
map("<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })

-- Top Pickers & Explorer
map("<leader>e", function() Snacks.explorer() end, { desc = "Explorer" })
map("<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
map("<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
map("<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })

-- find
map("<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
map("<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
map("<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
map("<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
map("<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })

-- git
map("<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
map("<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
map("<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
map("<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
map("<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
map("<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
map("<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
map("<leader>ga", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
map("<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" }, { "n", "x" })

-- Grep
map("<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
map("<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
map("<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
map("<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" }, { "n", "x" })

-- search
map('<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
map("<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
map("<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
map("<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
map("<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
map("<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
map("<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
map("<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
map("<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
map("<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
map("<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
map("<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
map("<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
map("<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
map("<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
map("<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- LSP
map("gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
map("gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
map("gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
map("gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
map("gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
map("gai", function() Snacks.picker.lsp_incoming_calls() end, { desc = "C[a]lls Incoming" })
map("gao", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "C[a]lls Outgoing" })
map("<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "LSP Info" })
map("<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
map("<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })

-- Other
map("<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
map("<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
map("]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" }, { "n", "t" })
map("[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" }, { "n", "t" })
map("<C-/>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" }, { "n", "t" })
