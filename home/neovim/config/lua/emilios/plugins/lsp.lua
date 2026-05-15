-- Migrated to nvim 0.11+ vim.lsp.config API.

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
    vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  end,
})

vim.lsp.config('*', {
  capabilities = capabilities,
})

local servers = {
  clangd = {},
  rust_analyzer = {},
  pyright = {},
  ocamllsp = {},
  graphql = {},
  hls = {
    cmd = { 'haskell-language-server', '--lsp' },
    settings = {
      haskell = {
        formattingProvider = 'fourmolu',
      },
    },
  },
  nil_ls = {},
  rescriptls = {
    cmd = { 'npx', '@rescript/language-server@^1.72.0', '--stdio' },
    init_options = {
      extensionConfiguration = {
        askToStartBuild = false,
        incrementalTypechecking = { debugLogging = true, enabled = true },
      },
    },
  },
  tailwindcss = {
    settings = {
      tailwindCSS = {
        colorDecorators = false,
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        telemetry = { enable = false },
      },
    },
  },
  purescriptls = {},
  vtsls = {
    cmd = { 'npx', '@vtsls/language-server', '--stdio' },
  },

  rescript_relay_lsp = {
    cmd = { 'npx', 'rescript-relay-compiler', 'lsp' },
    filetypes = { 'rescript', 'typescript', 'typescriptreact' },
    root_markers = { 'relay.config.js' },
  },
  relay_lsp = {
    cmd = { './node_modules/relay-compiler/macos-arm64/relay', 'lsp' },
    filetypes = { 'typescript', 'typescriptreact' },
    root_markers = { 'relay.config.js' },
  },
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end
