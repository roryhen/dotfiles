return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
    },
  },
}
