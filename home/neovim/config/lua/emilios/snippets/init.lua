local ls = require("luasnip")
local rescript_relay_fragment = require('emilios.snippets.rescript.relay_fragment').snippet

ls.add_snippets('rescript', {
  rescript_relay_fragment
}, { key = 'rescript' })
