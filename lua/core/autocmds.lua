local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local original_select = vim.ui.select
vim.ui.select = function(items, opts, on_choice)
  if #items == 1 then
    local item = items[1]
    local format_item = opts.format_item or tostring
    local preview = format_item(item)
    vim.api.nvim_echo({{preview, "Normal"}}, false, {})
    vim.defer_fn(function()
      vim.cmd("redraw")
      on_choice(item, 1)
    end, 500)
  else
    original_select(items, opts, on_choice)
  end
end

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

local indent_group = augroup("IndentSettings", { clear = true })

-- Default: 2 spaces for most filetypes
autocmd("FileType", {
  group = indent_group,
  pattern = "*",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Python/Go: 4 spaces
autocmd("FileType", {
  group = indent_group,
  pattern = { "python", "go" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Force cursor colors after colorscheme loads
augroup("CursorColors", { clear = true })
autocmd({ "VimEnter", "ColorScheme" }, {
  group = "CursorColors",
  pattern = "*",
  callback = function()
    vim.cmd([[
      highlight Cursor guifg=#000000 guibg=#4fc1ff ctermfg=0 ctermbg=81
      highlight lCursor guifg=#000000 guibg=#4fc1ff ctermfg=0 ctermbg=81
    ]])
  end,
})

-- Project detection on session restore
augroup("ProjectDetection", { clear = true })
autocmd("User", {
  group = "ProjectDetection",
  pattern = "AutoSessionRestored",
  callback = function()
    -- Defer to ensure all plugins are loaded
    vim.defer_fn(function()
      require("core.project").setup_project()
    end, 500)
  end,
})

-- Also run on VimEnter for manual opens
autocmd("VimEnter", {
  group = "ProjectDetection",
  callback = function()
    -- Only run if not restored from session
    if vim.g.SessionLoad ~= 1 then
      vim.defer_fn(function()
        require("core.project").setup_project()
      end, 1000)
    end
  end,
})
