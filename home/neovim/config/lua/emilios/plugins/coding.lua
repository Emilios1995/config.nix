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

-- use `gS` to toggle between arguments being on a single
-- line or split into lines. arguments can be function args,
-- object/record attrs, etc.
require('mini.splitjoin').setup()


-- completion


local cmp = require("cmp")
local defaults = require("cmp.config.default")()
cmp.setup(
  {
    completion = {
      completeopt = "menu,menuone,noinsert",
      autocomplete = false
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<C-Y>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<C-s>"] = cmp.mapping.complete {
        config = {
          sources = {
            { name = "cody" },
          },
        },
      },
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "luasnip" },
      { name = "buffer" },
    }),
    cmdline = {
      enable = false,
      options = {
        {
          type = ":",
          sources = {
            { name = "path" },
            { name = "cmdline" },
          },
        },
        {
          type = { "/", "?" },
          sources = {
            { name = "buffer" },
          },
        },
      },
    },
    sorting = {
      comparators = {
        cmp.config.compare.score,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.kind,
        cmp.config.compare.order,
        cmp.config.compare.sort_text,
      },
    },
  }
)
