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

-- Custom components
local function lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= "null-ls" then
      table.insert(names, client.name)
    end
  end

  if #names == 0 then
    return ""
  end

  return "[" .. table.concat(names, ",") .. "]"
end

local function macro_recording()
  local recording = vim.fn.reg_recording()
  if recording ~= "" then
    return "@" .. recording
  end
  return ""
end

local function search_count()
  if vim.v.hlsearch == 0 then
    return ""
  end
  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
  if not ok or result.current == 0 then
    return ""
  end
  return string.format("[%d/%d]", result.current, math.min(result.total, result.maxcount))
end

require("lualine").setup({
  options = {
    theme = theme,
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "dashboard", "alpha" },
    },
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      },
    },
    lualine_c = {
      { "filename", path = 1, symbols = { modified = "[+]", readonly = "[-]", unnamed = "[No Name]" } },
      { macro_recording, color = { fg = colors.red, gui = "bold" } },
      { search_count, color = { fg = colors.cyan } },
    },
    lualine_x = {
      { lsp_status, color = { fg = colors.purple } },
      "encoding",
      { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
      "filetype"
    },
    lualine_y = {
      "progress",
      { "filesize", color = { fg = colors.gray } },
    },
    lualine_z = {
      "location",
      { "selectioncount", color = { fg = colors.cyan } },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { "nvim-tree", "toggleterm", "oil", "trouble" },
})

