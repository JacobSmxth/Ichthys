-- Performance-focused settings

local o = vim.opt

-- Line numbers
o.number = true
o.relativenumber = true

-- 2 space indent
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true

-- Mouse configuration (controlled by preferences)
local prefs = require("core.preferences")
local mouse_enabled = prefs.get("mouse") == "true"
o.mouse = mouse_enabled and "a" or ""

-- System clipboard
o.clipboard = "unnamedplus"

-- Auto-write buffers without confirmation prompts
o.confirm = false
o.autowriteall = true

local undodir = vim.fn.stdpath("cache") .. "/undo"
vim.fn.mkdir(undodir, "p")
o.undodir = undodir
o.undofile = true
o.undolevels = 1000
o.undoreload = 10000

-- Cursorline highlight
o.cursorline = true

-- Make cursor block - terminal controls colors
o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- Keep context
o.scrolloff = 8
o.sidescrolloff = 8

-- Split directions
o.splitright = true
o.splitbelow = true

-- Always signcolumn
o.signcolumn = "yes"

-- Performance opts
o.updatetime = 250
o.timeoutlen = 300

-- Search settings
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- UI preferences
o.wrap = false
o.termguicolors = true
o.showmode = false
o.showtabline = 1
o.conceallevel = 0
o.pumheight = 10

-- No swap/backup
o.backup = false
o.writebackup = false
o.swapfile = false

-- Allow hiding modified buffers
o.hidden = true

-- Simple statusline
o.statusline = "%#StatusLine# %{toupper(mode())} %#StatusLineNC#| %f %m %= %l:%c | %Y "
o.laststatus = 2

-- Space leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw (using Oil instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
