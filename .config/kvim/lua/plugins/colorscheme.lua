return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function(_, opts)
      require("nightfox").setup(opts)

      -- Load the colorscheme here.
      vim.cmd.colorscheme("carbonfox")
    end,
  },
}
