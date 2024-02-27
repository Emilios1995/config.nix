local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local k = require("luasnip.nodes.key_indexer").new_key

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local lspconfig = require('lspconfig')

local M = {}

local function buf_root(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, 'graphql')
  local tree = parser:parse()
  return tree[1]:root()
end


local function add_buff(filename)
  local bufnr = vim.fn.bufadd(filename)
  vim.fn.bufload(filename)
  return bufnr
end


local function get_project_root()
  local project_root = lspconfig.util.root_pattern("relay.config.js")(vim.fn.expand("%:p:h"))
  return project_root
end

local function get_schema_location()
  local project_root = get_project_root()
  return project_root .. "/schema.graphql"
end

local function get_graphql_types()
  local bufnr = add_buff(get_schema_location())
  local root = buf_root(bufnr)
  local query = vim.treesitter.query.parse("graphql", [[
    [(object_type_definition (name) @name )
     (interface_type_definition (name) @intf_name )
     (union_type_definition (name) @union_name)
    ]
  ]])

  local results = {}

  for _, node in query:iter_captures(root, bufnr) do
    local v = vim.treesitter.get_node_text(node, bufnr)
    table.insert(results, v)
  end
  return results
end

local function get_current_filename()
  local filename = vim.fn.expand("%:t:r")
  return string.gsub(filename, "_", "")
end

local function make_type_choice_snippet()
  return function()
    local results = get_graphql_types()
    local nodes = {}
    for _, v in ipairs(results) do
      table.insert(nodes, t(v))
    end
    return sn(nil, {
      c(1, nodes)
    })
  end
end

local function get_current_node_ancestor_modules()
  local node = vim.treesitter.get_node()
  if node == nil then
    return {}
  end
  local tree = node:tree()
  local tree_root = tree:root()
  local ancestors = {}
  while node ~= nil and node ~= tree_root do
    if (node:type() == "module_declaration") then
      local module_ident = node:child(1):child(0)
      if module_ident == nil then
        break
      end
      local name = vim.treesitter.get_node_text(module_ident, 0)
      table.insert(ancestors, name)
    end
    node = node:parent()
  end
  -- discard the first ancestor, which is the fragment module created by the snippet
  table.remove(ancestors, 1)
  return ancestors
end


local function reverse_table(x)
  local rev = {}
  for idx = #x, 1, -1 do
    rev[#rev + 1] = x[idx]
  end
  return rev
end

local function decapitalize(str)
  return string.lower(str:sub(1, 1)) .. str:sub(2)
end


local function make_fragment_name(ancestor_modules, type)
  -- reverse the list of ancestor modules
  local ancestors = table.concat(reverse_table(ancestor_modules), "_")
  local filename = get_current_filename()
  local result = filename
  if ancestors ~= "" then
    result = filename .. "_" .. ancestors
  end
  if type ~= "" and type ~= nil then
    print("type: " .. type)
    result = result .. "_" .. decapitalize(type)
  end
  return result
end


local function fragment_snippet_node()
  return sn(nil,
    fmta([[
       module <module_name>Fragment = %relay(`
         fragment <fragment_name> on <fragment_type> {
           <selections>
         }
       `)
  ]], {
      module_name = i(1, "", { key = "module_name" }),
      fragment_name = f(function(args)
        local ancestors = get_current_node_ancestor_modules()
        local type = args[1][1]
        return make_fragment_name(ancestors, type)
      end, { 2 }, nil),
      fragment_type = d(2, make_type_choice_snippet(), {}),
      selections = i(3)
    })
  )
end

M.snippets = {
  s(
    { trig = "rfc", desc = "Adds a Relay fragment and a React component.", name = "Relay fragment component" },
    fmta([[
       <fragment>

       @react.component
       let make = (~<prop_name>) =>> {
         let <prop_name_rep> = <module_name>Fragment.use(<prop_name_rep>)

         <component_body>
       }
    ]], {
      fragment = d(1, fragment_snippet_node, {}),
      prop_name = i(2),
      prop_name_rep = rep(2),
      module_name = rep(k("module_name")),
      component_body = i(0, "React.null")
    })
  ),
  s(
    { trig = "rf", name = "Relay fragment", desc = "Adds a Relay fragment" },
    { d(1, fragment_snippet_node, {}) }
  ),
  s(
    { trig = "rfh", desc = "Adds a Relay fragment and a React hook.", name = "Relay fragment hook" },
    fmta([[
       <fragment>

       let use = (~<prop_name>) =>> {
         let <prop_name_rep> = <module_name>Fragment.use(<prop_name_rep>)

         <body>
       }
    ]], {
      fragment = d(1, fragment_snippet_node, {}),
      prop_name = i(2),
      prop_name_rep = rep(2),
      module_name = rep(k("module_name")),
      body = i(0, "()")
    })
  ),

}


return M
