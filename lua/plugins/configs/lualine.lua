-- lua/plugins/configs/lualine.lua
-- VSCode-inspired statusline theme

local colors = {
  bg = "#1e1e1e",
  fg = "#d4d4d4",
  blue = "#007acc",
  cyan = "#4fc1ff",
  green = "#608b4e",
  purple = "#c586c0",
  red = "#f44747",
  orange = "#ff8800",
  yellow = "#dcdcaa",
  gray = "#858585",
  darkgray = "#2d2d30",
  lightgray = "#cccccc",
}

local theme = {
  normal = {
    a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
    b = { fg = colors.lightgray, bg = colors.darkgray },
    c = { fg = colors.gray, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.red, gui = "bold" },
  },
  command = {
    a = { fg = colors.bg, bg = colors.cyan, gui = "bold" },
  },
  inactive = {
    a = { fg = colors.gray, bg = colors.darkgray },
    b = { fg = colors.gray, bg = colors.darkgray },
    c = { fg = colors.gray, bg = colors.bg },
  },
}

require("lualine").setup({
  options = {
    theme = theme,
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "dashboard", "alpha" },
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

