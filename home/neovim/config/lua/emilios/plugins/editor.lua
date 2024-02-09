-- File explorer
require('oil').setup({
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
  },
  use_default_keymaps = false,
  view_options = {
    show_hidden = true,
  }
})

vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

-- Telescope
local telescope = require 'telescope'
local actions = require 'telescope.actions'

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-f>"] = actions.to_fuzzy_refine },
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

telescope.load_extension 'fzf'
telescope.load_extension 'live_grep_args'

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', telescope.extensions.live_grep_args.live_grep_args, {})
vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})


vim.keymap.set('n', '<leader>lr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>lci', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>lco', builtin.lsp_outgoing_calls, {})
vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>lS', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>lt', builtin.lsp_type_definitions, {})


-- navigation between vim panes and tmux
require('Navigator').setup()

vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>NavigatorDown<CR>')

require('copilot').setup({
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<tab>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})

-- copy GitHub URLs to clipboard
require "gitlinker".setup()

require('gitsigns').setup()

require('neogit').setup()

-- NoNeckPain

vim.keymap.set('n', '<leader>n', "<CMD>NoNeckPain<CR>", { desc = "Toggle NoNeckPain" })


-- Grapple (file tagging, similar to harpoon)

require("grapple").setup({
  scope = "git_branch",

  ---Window options used for the popup menu
  popup_options = {
    relative = "editor",
    width = 60,
    height = 12,
    style = "minimal",
    focusable = false,
    border = "single",
  },
})


vim.keymap.set("n", "<leader>mt", require("grapple").toggle)
vim.keymap.set("n", "<leader>mm", require("grapple").popup_tags)

vim.keymap.set("n", "<leader>mn", function()
  require("grapple").select({ key = "{name}" })
end)

vim.keymap.set("n", "<leader>mN", function()
  require("grapple").toggle({ key = "{name}" })
end)

vim.keymap.set("n", "<leader>m1", function()
  require("grapple").select({ key = 1 })
end)

vim.keymap.set("n", "<leader>m2", function()
  require("grapple").select({ key = 2 })
end)

vim.keymap.set("n", "<leader>m3", function()
  require("grapple").select({ key = 3 })
end)

vim.keymap.set("n", "<leader>m4", function()
  require("grapple").select({ key = 4 })
end)

vim.keymap.set("n", "<leader>m5", function()
  require("grapple").select({ key = 5 })
end)


vim.keymap.set("n", "<leader>mq", require("grapple").cycle_backward)
vim.keymap.set("n", "<leader>mp", require("grapple").cycle_forward)

-- Buffjump (jump to next/previously visited buffer)
require("bufjump").setup({
  forward = "<C-n>",
  backward = "<C-p>",
  on_success = nil
})


-- Noice
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
    messages = {
      -- Messages shown by lsp servers
      enabled = true,
      view = "mini",
      opts = {},
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true,         -- use a classic bottom cmdline for search
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
  messages = {
    -- NOTE: If you enable messages, then the cmdline is enabled automatically.
    -- This is a current Neovim limitation.
    enabled = true,              -- enables the Noice messages UI
    view = "mini",               -- default view for messages
    view_error = "mini",         -- view for errors
    view_warn = "mini",          -- view for warnings
    view_history = "messages",   -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
  message = {
    -- Messages shown by lsp servers
    enabled = true,
    view = "mini",
    opts = {},
  },
  views = {
    cmdline_popup = {
      position = {
        row = 20,
        col = "50%",
      },
      size = {
        min_width = 60,
        width = "auto",
        height = "auto",
      },
    },
    cmdline_popupmenu = {
      relative = "editor",
      position = {
        row = 23,
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
        max_height = 15,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
      },
    },
  }
})
