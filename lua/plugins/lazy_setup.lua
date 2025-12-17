-- Plugin setup using lazy.nvim
-- Specs are organized in lua/plugins/specs/

local function merge_specs(...)
  local result = {}
  for _, spec_list in ipairs({ ... }) do
    for _, spec in ipairs(spec_list) do
      table.insert(result, spec)
    end
  end
  return result
end

-- Load all plugin specs
local specs = merge_specs(
  require("plugins.specs.ui"),
  require("plugins.specs.lsp"),
  require("plugins.specs.completion"),
  require("plugins.specs.treesitter"),
  require("plugins.specs.navigation"),
  require("plugins.specs.git"),
  require("plugins.specs.editor"),
  require("plugins.specs.tools"),
  require("plugins.specs.misc")
)

require("lazy").setup(specs, {
  ui = {
    border = "single",
    icons = {
      cmd = "[CMD]",
      config = "[CFG]",
      event = "[EVT]",
      ft = "[FT]",
      init = "[INIT]",
      keys = "[KEY]",
      plugin = "[PLG]",
      runtime = "[RUN]",
      require = "[REQ]",
      source = "[SRC]",
      start = "[START]",
      task = "[TASK]",
      lazy = "[LAZY]",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
