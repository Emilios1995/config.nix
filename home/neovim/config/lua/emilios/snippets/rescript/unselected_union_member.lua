local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local l = require('luasnip.extras').lambda

local M = {}


M.snippet = s(
  {
    trig = "uum",
    dscr = "Meant to be inserted inside a switch expression over a Relay union to make it exhaustive"
  },
  fmta([[
    | #UnselectedUnionMember(s) =>> 
      UnselectedUnionMemberError.raise(`Unselected <name> ${s}`)
  ]], {
    name = i(0)
  })
)

return M
