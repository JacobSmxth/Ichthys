-- ============================================================================
-- CORE MAPPINGS - Global Keybindings
-- ============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- DISABLE ARROW KEYS (force hjkl)
-- ============================================================================
map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)
map("n", "<Left>", "<Nop>", opts)
map("n", "<Right>", "<Nop>", opts)

map("i", "<Up>", "<Nop>", opts)
map("i", "<Down>", "<Nop>", opts)
map("i", "<Left>", "<Nop>", opts)
map("i", "<Right>", "<Nop>", opts)

map("v", "<Up>", "<Nop>", opts)
map("v", "<Down>", "<Nop>", opts)
map("v", "<Left>", "<Nop>", opts)
map("v", "<Right>", "<Nop>", opts)

-- ============================================================================
-- LEADER MAPPINGS (Space as leader)
-- ============================================================================

-- File operations
map("n", "<leader>w", ":w<CR>", opts)                      -- Save file
map("n", "<leader>q", ":q<CR>", opts)                      -- Quit
map("n", "<leader>x", ":wq<CR>", opts)                     -- Save and quit

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)         -- Toggle file tree

-- Formatting
map("n", "<leader>f", function()
  local conform_ok, conform = pcall(require, "conform")
  if conform_ok then
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { noremap = true, silent = true, desc = "Format buffer" })

-- Format selection in visual mode
map("v", "<leader>f", function()
  local conform_ok, conform = pcall(require, "conform")
  if conform_ok then
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { noremap = true, silent = true, desc = "Format selection" })

-- Fix indentation for entire file (like IntelliJ's reindent)
map("n", "<leader>i", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { noremap = true, silent = true, desc = "Fix indentation" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)  -- Find files
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)   -- Live grep
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)     -- Find buffers

-- ============================================================================
-- ESSENTIAL MAPPINGS
-- ============================================================================

-- jj to escape insert mode
map("i", "jj", "<Esc>", opts)

-- Buffer navigation
map("n", "<S-L>", ":bnext<CR>", opts)                      -- Next buffer
map("n", "<S-H>", ":bprevious<CR>", opts)                  -- Previous buffer

-- Clear search highlight
map("n", "<Esc>", ":noh<CR>", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- ============================================================================
-- LSP MAPPINGS (set on attach in lsp.lua)
-- ============================================================================
-- These are defined in lua/plugins/configs/lsp.lua on_attach:
--   gd - Go to definition
--   gr - Find references
--   K - Hover documentation
--   <leader>rn - Rename symbol
--   <leader>ca - Code action
--   <leader>oi - Organize imports (Java only)

-- ============================================================================
-- LANGUAGE-SPECIFIC MAPPINGS (defined in ftplugin/<language>.lua)
-- ============================================================================
-- JAVA (ftplugin/java.lua):
--   <leader>jc - Compile current Java file
--   <leader>jr - Compile and run (auto-detect main)
--   <leader>jm - Compile and run (specify main class)
--   <leader>jg - Run with Gradle (bootRun for Spring Boot)
--   <leader>jb - Build with Gradle
--   <leader>jt - Run tests with Gradle
--
-- C (ftplugin/c.lua):
--   <leader>cc - Compile with gcc
--   <leader>cr - Compile and run
--   <leader>cd - Compile with debug symbols
--   <leader>cx - Run compiled executable
--   <leader>cm - Build with make
--   <leader>cM - Clean make build
--
-- C++ (ftplugin/cpp.lua):
--   <leader>cc - Compile with g++
--   <leader>cr - Compile and run
--   <leader>cd - Compile with debug symbols
--   <leader>cx - Run compiled executable
--   <leader>cm - Build with make
--   <leader>cM - Clean make build

-- ============================================================================
-- COMMENT MAPPINGS (provided by Comment.nvim)
-- ============================================================================
-- gcc - Toggle line comment
-- gc in visual - Toggle block comment
