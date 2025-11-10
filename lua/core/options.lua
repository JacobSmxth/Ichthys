-- ============================================================================
-- CORE OPTIONS - Hacker Config Performance Settings
-- ============================================================================

local o = vim.opt

-- Line numbers
o.number = true            -- absolute line numbers
o.relativenumber = true    -- relative line numbers

-- Tab/indent settings (2 spaces default, matches google-java-format)
o.expandtab = true         -- spaces instead of tabs
o.shiftwidth = 2           -- indent size
o.tabstop = 2              -- tab width
o.softtabstop = 2          -- backspace over spaces
o.smartindent = true       -- smart autoindenting

-- Disable mouse
o.mouse = ""               -- no mouse support

-- Clipboard
o.clipboard = "unnamedplus" -- system clipboard integration

-- Undo persistence
local undodir = vim.fn.stdpath("cache") .. "/undo"
vim.fn.mkdir(undodir, "p")
o.undodir = undodir
o.undofile = true
o.undolevels = 1000
o.undoreload = 10000

-- Cursorline
o.cursorline = true        -- highlight current line

-- Scrolling
o.scrolloff = 8            -- keep 8 lines above/below cursor
o.sidescrolloff = 8        -- keep 8 columns left/right of cursor

-- Splits
o.splitright = true        -- vertical split to right
o.splitbelow = true        -- horizontal split below

-- Signcolumn
o.signcolumn = "yes"       -- always show signcolumn

-- Performance
o.lazyredraw = true        -- faster macro execution
o.updatetime = 250         -- faster completion
o.timeoutlen = 300         -- faster key sequence completion

-- Search
o.ignorecase = true        -- case insensitive search
o.smartcase = true         -- case sensitive if uppercase present
o.hlsearch = true          -- highlight search results
o.incsearch = true         -- incremental search

-- UI
o.wrap = false             -- no line wrap
o.termguicolors = true     -- true-color support
o.showmode = false         -- hide mode (shown in statusline)
o.showtabline = 1          -- show tabline only if tabs exist
o.conceallevel = 0         -- show concealed text
o.pumheight = 10           -- popup menu height

-- Files
o.backup = false           -- no backup file
o.writebackup = false      -- no backup file while editing
o.swapfile = false         -- no swap file

-- Simple green statusline: mode | file | line:col | filetype
o.statusline = "%#StatusLine# %{toupper(mode())} %#StatusLineNC#| %f %m %= %l:%c | %Y "
o.laststatus = 2           -- always show statusline

-- Leader key
vim.g.mapleader = " "      -- space as leader key
vim.g.maplocalleader = " "
