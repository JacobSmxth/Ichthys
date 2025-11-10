-- ============================================================================
-- CORE AUTOCMDS - Hacker Config Autocommands
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- TRIM TRAILING WHITESPACE ON SAVE
-- ============================================================================
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- ============================================================================
-- HIGHLIGHT ON YANK
-- ============================================================================
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

-- ============================================================================
-- FORMAT ON SAVE FOR JAVA
-- ============================================================================
augroup("JavaFormatOnSave", { clear = true })
autocmd("BufWritePre", {
  group = "JavaFormatOnSave",
  pattern = "*.java",
  callback = function()
    -- Use conform.nvim for formatting
    require("conform").format({ timeout_ms = 2000, lsp_fallback = true })
  end,
})

-- ============================================================================
-- RESTORE CURSOR POSITION
-- ============================================================================
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

-- ============================================================================
-- DISABLE AUTO-COMMENT ON NEW LINE
-- ============================================================================
augroup("DisableAutoComment", { clear = true })
autocmd("FileType", {
  group = "DisableAutoComment",
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- ============================================================================
-- ENSURE PROPER INDENTATION SETTINGS
-- ============================================================================
augroup("IndentSettings", { clear = true })
autocmd("FileType", {
  group = "IndentSettings",
  pattern = "*",
  callback = function()
    -- Ensure expandtab is set (use spaces, not tabs)
    vim.opt_local.expandtab = true
    -- Default to 2 spaces (matches google-java-format and most modern standards)
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Override for specific filetypes that need 4 spaces
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
