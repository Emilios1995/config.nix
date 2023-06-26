require('mini.surround').setup()

-- vim.cmd "packadd nvim-treesitter"
require('nvim-treesitter.configs').setup {
  ensure_installed = {},

  highlight = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>"
    }
  }
}
