local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local l = require('luasnip.extras').lambda

local M = {}


--- We could improve this by getting the props from tree sitter
M.snippet = s(
  { trig = "feb", dscr = "fragment error boundary" },
  fmta([[
    @react.component
    let make = (~<props>) =>> {
      <<FragmentErrorBoundary fragmentDisplayName="<name>">>
        <<WithoutErrorBoundary <props_rep> />>
      <</FragmentErrorBoundary>>
    }
  ]], {
    props = i(1),
    name = i(2),
    props_rep = l(l._1:gsub("~",""):gsub(",",""), 1)
  })
)

return M
