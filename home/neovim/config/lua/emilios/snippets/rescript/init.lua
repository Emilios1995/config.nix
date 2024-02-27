local ls = require("luasnip")
local fragment_snippets = require('emilios.snippets.rescript.relay_fragment').snippets
local feb = require('emilios.snippets.rescript.fragment_error_boundary').snippet
local uum = require('emilios.snippets.rescript.unselected_union_member').snippet

local M = {}

M.setup = function()
  ls.add_snippets('rescript', fragment_snippets, { key = 'rescript_relay_fragments' })
  ls.add_snippets('rescript', {
    feb,
    uum
  }, { key = 'rescript' })
end

return M
