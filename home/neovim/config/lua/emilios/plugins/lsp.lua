local nvim_lsp = require('lspconfig')
local configs = require('lspconfig.configs')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local default_on_attach = function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.MiniCompletion.completefunc_lsp')
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
end

local mk_server = function(config)
  config = config or {}
  local on_attach = function(client, bufnr)
    default_on_attach(client, bufnr)
    if config.on_attach then
      config.on_attach(client, bufnr)
    end
  end
  return {
    on_attach = on_attach,
    cmd = config.cmd,
    filetypes = config.filetypes,
    root_dir = config.root_dir,
    settings = config.settings,
    init_options = config.init_options,
    capabilities = capabilities
  }
end


if not configs.rescript_relay_lsp then
  configs.rescript_relay_lsp = {
    default_config = {
      cmd = { "npx", "rescript-relay-compiler", "lsp" },
      filetypes = {
        "rescript",
        "typescript",
        "typescriptreact",
      },
      root_dir = nvim_lsp.util.root_pattern 'relay.config.js',
    },
    settings = {},
  }
end

local servers = {
  clangd = mk_server(),
  rust_analyzer = mk_server(),
  pyright = mk_server(),
  ocamllsp = mk_server(),
  graphql = mk_server(),
  hls = mk_server(
    {
      cmd = { "haskell-language-server", "--lsp" },
      settings = {
        haskell = {
          formattingProvider = "fourmolu"
        }
      }
    }
  ),
  nil_ls = mk_server(),
  rescriptls = mk_server {
    cmd = { "npx", "@rescript/language-server@1.50.0", "--stdio" },
    init_options = {
      extensionConfiguration = {
        askToStartBuild = false,
        incrementalTypechecking = { debugLogging = false, enabled = true }
      }
    },
  },
  tailwindcss = mk_server(),
  lua_ls = mk_server {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  rescript_relay_lsp = mk_server(),
  purescriptls = mk_server(),
  vtsls = mk_server {
    cmd = { "npx", "@vtsls/language-server", "--stdio" }
  }
}


-- Enable the following language servers
for server, config in pairs(servers) do
  nvim_lsp[server].setup(config)
end
