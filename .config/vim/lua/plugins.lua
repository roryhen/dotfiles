vim.pack.add({
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
})

vim.cmd.colorscheme("carbonfox")

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
