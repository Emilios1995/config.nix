require("emilios.globals")
require("emilios.settings")
require("emilios.plugins.coding")
require("emilios.plugins.lsp")
require("emilios.plugins.editor")

require("emilios.snippets")



local function perform_melange_replacements()
  local replacements = {
    { "TanNgBsBase",                       "Tan_base" },
    { "TanNgBsNode",                       "Tan_node" },
    { "TanNgBsNodeFetch",                  "Node_fetch" },
    { "TanNgBsEnvConfig.Env_config",       "Env_config" },
    { "TanNgBsPgPromise.Pgp",              "Pgp" },
    { "TanLogger",                         "Tan_logger" },
    { "Repromise",                         "Promise" },
    { "Promise.wait",                      "Promise.get" },
    { "Promise.andThen",                   "Promise.flatMap" },
    { "|> Promise\\.",                     "|. Promise." },
    { "%bs",                               "%mel" },
    { "@bs",                               "@mel" },
    { "TanNgBsGcp",                        "Gcp" },
    { "TanClient",                         "Common_client" },
    { "module Pgp = TanNgBsPgPromise.Pgp", "" },
    { "Promise.Rejectable.toJsPromise",    "Promise.Js.toBsPromise" },
    { "Promise.Rejectable",                "Promise.Js" },
    { "Null_undefined",                    "Nullable" }
  }

  -- Perform the replacements
  for _, replacement in ipairs(replacements) do
    local old_pattern = replacement[1]
    local new_pattern = replacement[2]
    vim.cmd(string.format("%%s/%s/%s/ge", old_pattern, new_pattern))
  end
end

-- Define a custom command to call the function
vim.api.nvim_create_user_command(
  'MelangeReplacements',
  function() perform_melange_replacements() end,
  { nargs = 0 }
)
