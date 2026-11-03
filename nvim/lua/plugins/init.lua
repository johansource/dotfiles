-- Plugins
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
  },
  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
  }
})

require("plugins.treesitter")
require("plugins.telescope")
