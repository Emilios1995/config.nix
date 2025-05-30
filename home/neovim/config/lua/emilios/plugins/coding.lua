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

local ls = require("luasnip")
local types = require "luasnip.util.types"

ls.setup({
  history = true,
  enable_autosnippets = false,
  update_events = { "TextChanged", "TextChangedI" },
  region_check_events = "InsertEnter",
  delete_check_events = "InsertLeave",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <-- Current selection", "Comment" } },
      },
    },
  },
})


local cmp = require("cmp")

cmp.setup(
---@diagnostic disable: redundant-parameter
  {
    completion = {
      completeopt = "menu,menuone,noinsert",
      --autocomplete = true
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        elseif ls.expand_or_locally_jumpable() then
          ls.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-p>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        elseif ls.jumpable(-1) then
          ls.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-y>"] = cmp.mapping.confirm({
        select = true,
      }),
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

---@diagnostic enable: redundant-parameter

vim.keymap.set({ "i" }, "<C-k>", function() ls.expand() end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-u>", function()
  require('luasnip.extras.select_choice')()
end, { silent = true })
