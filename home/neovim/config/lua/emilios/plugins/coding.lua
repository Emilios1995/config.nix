require('mini.surround').setup()

require('nvim-treesitter.configs').setup {
  ensure_installed = {},

  highlight = {
    enable = true,
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer"
      },
      goto_next_end = {
        ["]F"] = "@function.outer"
      },
      goto_previous_start = {
        ["[f"] = "@function.outer"
      },
      goto_previous_end = {
        ["[F"] = "@function.outer"
      }
    }
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

local mini_ai = require('mini.ai')
mini_ai.setup {
  custom_textobjects = {
    F = mini_ai.gen_spec.treesitter({ 
      a = '@function.outer', i = '@function.inner' 
    })
  }
}

require('mini.comment').setup()
