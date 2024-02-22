local ls = require("luasnip")
local fragment_snippet = require('emilios.snippets.rescript.relay_fragment').snippet

local M = {}

M.setup = function()
  ls.add_snippets('rescript', {
    fragment_snippet
  }, { key = 'rescript' })
end

return M
