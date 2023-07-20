-- File explorer
require('oil').setup()

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

require('mini.completion').setup({
  lsp_completion = { source_func = 'omnifunc', auto_setup = false }
})

-- select and accept the first item with <C-y>
vim.keymap.set('i', '<C-y>', function()
  local complete_info = vim.fn.complete_info({ 'selected', 'items' })
  local item_selected = complete_info['selected'] ~= -1
  local has_items = #complete_info['items'] > 0
  local popup_open = vim.fn.pumvisible() == 1
  return (not item_selected) and popup_open and has_items and "<C-n><C-y>" or "<C-y>"
end, { expr = true })



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
