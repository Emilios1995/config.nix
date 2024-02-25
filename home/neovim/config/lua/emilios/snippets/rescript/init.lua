local ls = require("luasnip")
local fragment = require('emilios.snippets.rescript.relay_fragment').snippet
local feb = require('emilios.snippets.rescript.fragment_error_boundary').snippet
local uum = require('emilios.snippets.rescript.unselected_union_member').snippet

local M = {}

M.setup = function()
  ls.add_snippets('rescript', {
    fragment,
    feb,
    uum
  }, { key = 'rescript' })
end

return M
