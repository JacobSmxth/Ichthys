-- Appearance configuration: Theme settings

local M = {}

-- Apply gruvbox-material theme
function M.apply_theme()
  vim.g.gruvbox_material_background = "medium"
  vim.g.gruvbox_material_better_performance = 1
  vim.cmd.colorscheme("gruvbox-material")
end

-- Initialize appearance
function M.setup()
  M.apply_theme()
end

return M
