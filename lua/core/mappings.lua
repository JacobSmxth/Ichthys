-- Global keybindings

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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

-- File ops
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>wq", ":wq<CR>", opts)

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

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

map("n", "<leader>i", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { noremap = true, silent = true, desc = "Fix indentation" })

-- Screen jumps
map("n", "H", "H", opts)
map("n", "M", "M", opts)
map("n", "L", "L", opts)

-- Fuzzy search
map("n", "/", ":Telescope current_buffer_fuzzy_find<CR>", opts)

-- Traditional search (? searches backward in vim)
map("n", "?", "?", { noremap = true, desc = "Traditional backward search" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
map("n", "<leader>fr", ":Telescope oldfiles<CR>", opts)
map("n", "<leader>fc", ":Telescope commands<CR>", opts)

-- Buffer navigation
map("n", "<leader><leader>", "<C-^>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Quickfix
map("n", "]q", ":cnext<CR>", opts)
map("n", "[q", ":cprev<CR>", opts)

map("i", "jj", "<Esc>", opts)

-- Blank line without entering insert mode
map("n", "<leader>o", "o<Esc>", opts)
map("n", "<leader>O", "O<Esc>", opts)

-- Buffer switch
map("n", "<S-L>", ":bnext<CR>", opts)
map("n", "<S-H>", ":bprevious<CR>", opts)

map("n", "<Esc>", ":noh<CR>", opts)

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Window splits
map("n", "<leader>sv", ":vsplit<CR>", opts)
map("n", "<leader>sh", ":split<CR>", opts)
map("n", "<leader>sc", ":close<CR>", opts)

map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- LSP mappings in lsp.lua:
--   gd, gr, K, <leader>rn, <leader>ca, <leader>oi

-- Language mappings in ftplugin/*.lua
