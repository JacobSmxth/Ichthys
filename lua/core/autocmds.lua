-- Auto commands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 200,
    })
  end,
})

augroup("JavaFormatOnSave", { clear = true })
autocmd("BufWritePre", {
  group = "JavaFormatOnSave",
  pattern = "*.java",
  callback = function()
    require("conform").format({ timeout_ms = 2000, lsp_fallback = true })
  end,
})

augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

augroup("DisableAutoComment", { clear = true })
autocmd("FileType", {
  group = "DisableAutoComment",
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

augroup("IndentSettings", { clear = true })
autocmd("FileType", {
  group = "IndentSettings",
  pattern = "*",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Python/Go override
autocmd("FileType", {
  group = "IndentSettings",
  pattern = { "python", "go" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})
