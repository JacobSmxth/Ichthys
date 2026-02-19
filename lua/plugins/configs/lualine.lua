-- Lualine config — uses gruvbox-material theme

local function lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end

  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= "null-ls" then
      table.insert(names, client.name)
    end
  end

  if #names == 0 then return "" end
  return "[" .. table.concat(names, ",") .. "]"
end

local function macro_recording()
  local recording = vim.fn.reg_recording()
  if recording ~= "" then return "@" .. recording end
  return ""
end

local function search_count()
  if vim.v.hlsearch == 0 then return "" end
  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
  if not ok or result.current == 0 then return "" end
  return string.format("[%d/%d]", result.current, math.min(result.total, result.maxcount))
end

require("lualine").setup({
  options = {
    theme = "gruvbox-material",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "dashboard", "alpha", "neo-tree" },
    },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
      },
    },
    lualine_c = {
      { "filename", path = 1, symbols = { modified = "[+]", readonly = "[-]", unnamed = "[No Name]" } },
      { macro_recording, color = { gui = "bold" } },
      { search_count },
    },
    lualine_x = {
      { lsp_status },
      "encoding",
      { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location", { "selectioncount" } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { "neo-tree", "toggleterm", "trouble" },
})
