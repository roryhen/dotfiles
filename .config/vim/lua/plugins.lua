vim.pack.add({
  { src = "https://github.com/EdenEast/nightfox.nvim" },
})

vim.cmd.colorscheme("carbonfox")

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "liquid",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "query",
    "regex",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  },
})
