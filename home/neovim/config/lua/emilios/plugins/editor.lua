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
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
}

telescope.load_extension 'fzf'
telescope.load_extension 'live_grep_args'
telescope.load_extension 'ui-select'
telescope.load_extension 'luasnip'
telescope.load_extension 'grapple'

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', telescope.extensions.live_grep_args.live_grep_args, {})
vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})


vim.keymap.set('n', '<leader>lr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>lci', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>lco', builtin.lsp_outgoing_calls, {})
vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>lS', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>lt', builtin.lsp_type_definitions, {})

vim.keymap.set('n', '<leader>st', telescope.extensions.grapple.tags, {})
vim.keymap.set('n', '<leader>ss', telescope.extensions.luasnip.luasnip, {})


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
    auto_trigger = false,
    debounce = 75,
    keymap = {
      accept = "<tab>",
      accept_word = "<C-G>w",
      accept_line = "<C-G>l",
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
    ["no-neck-pain"] = false,
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


vim.keymap.set("n", "<leader>mt", function()
  require("grapple").toggle()
end)

vim.keymap.set("n", "<leader>mm", function()
  require("grapple").toggle_tags()
end)

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

require('gen').setup({
  model = "mixtral:instruct", -- The default model to use.
  display_mode = "float",     -- The display mode. Can be "float" or "split".
  show_prompt = false,        -- Shows the Prompt submitted to Ollama.
  show_model = false,         -- Displays which model you are using at the beginning of your chat session.
  no_auto_close = false,      -- Never closes the window automatically.
  -- init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
  -- Function to initialize Ollama
  --command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
  -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
  -- This can also be a lua function returning a command string, with options as the input parameter.
  -- The executed command must return a JSON object with { response, context }
  -- (context property is optional).

  debug = false -- Prints errors and the command which is run.
})

-- Linting

require('lint').linters_by_ft = {
  javascript = {
    "eslint_d"
  },
  typescript = {
    "eslint_d"
  },
  javascriptreact = {
    "eslint_d"
  },
  typescriptreact = {
    "eslint_d"
  }
}

vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
  callback = function()
    local lint_status, lint = pcall(require, "lint")
    if lint_status then
      lint.try_lint()
    end
  end,
})

-- Formatting

local util = require("conform.util")

require("conform").setup({
  formatters = {
    ["rescript-format"] = {
      command = util.from_node_modules("rescript"),
    },
    injected = {
      lang_to_ext = {
        graphql = "graphql"
      }
    }
  },
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    rescript = { "rescript-format", "injected" },
    graphql = { "prettier" },
    ocaml = { "ocamlformat" },
    sql = { "pg_format" }
  },
  log_level = vim.log.levels.DEBUG,
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

-- bind to leader f
vim.keymap.set("n", "<leader>f", "<CMD>Format<CR>", { desc = "Format" })


local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tailwind = {
  install_info = {
    url = "~/dev/tree-sitter-tailwind", -- local path or git repo
    -- optional entries:
    -- branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false,          -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
}
