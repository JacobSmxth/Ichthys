-- ============================================================================
-- TOGGLETERM CONFIGURATION
-- ============================================================================

require("toggleterm").setup({
  -- Size of terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,

  -- Open terminal in insert mode
  open_mapping = [[<C-\>]],

  -- Hide terminal number in buffer name
  hide_numbers = true,

  -- Shade terminal background
  shade_terminals = true,
  shading_factor = 2,

  -- Start in insert mode
  start_in_insert = true,

  -- Persist terminal size
  persist_size = true,

  -- Persist terminal mode (insert or normal)
  persist_mode = true,

  -- Terminal direction: 'vertical' | 'horizontal' | 'tab' | 'float'
  direction = "float",

  -- Close terminal window on process exit
  close_on_exit = true,

  -- Shell to use
  shell = vim.o.shell,

  -- Floating terminal configuration
  float_opts = {
    border = "curved",
    width = function()
      return math.floor(vim.o.columns * 0.9)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.9)
    end,
    winblend = 0,
  },
})

-- Terminal keybindings
-- These work inside the terminal
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  -- Ctrl+\ to toggle terminal (works in terminal mode)
  vim.keymap.set("t", [[<C-\>]], [[<Cmd>ToggleTerm<CR>]], opts)
  -- Esc to enter normal mode in terminal
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
  -- Ctrl+h/j/k/l for navigation in terminal mode
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- Apply terminal keymaps when terminal opens
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
