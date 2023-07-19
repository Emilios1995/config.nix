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
  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
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

-- add, replace, remove surrounding pairs of chars
require('mini.surround').setup()

require('mini.comment').setup()

-- `[` and `]` keymaps to jump to next/prev
-- buffer, file, quickfix item, etc.
require('mini.bracketed').setup()

-- extend `f` and `t` to work on multiple lines.
-- (sometimes faster than searching for a pattern.)
require('mini.jump').setup({
  mappings = {
    -- by default this is mapped to ; which i prefer mapping to :
    repeat_jump = ""
  }
})

-- auto pairing
require('mini.pairs').setup()

-- using this just for the scrolling animation,
-- which makes <C-u> and <C-d> easier to follow
require('mini.animate').setup {
  scroll = { enable = true },
  close = { enable = false },
  cursor = { enable = false },
  resize = { enable = false },
  open = { enable = false },
}

-- use `gS` to toggle between arguments being on a single
-- line or split into lines. arguments can be function args,
-- object/record attrs, etc.
require('mini.splitjoin').setup()
