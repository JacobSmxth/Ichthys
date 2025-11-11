-- ============================================================================
-- TREESITTER CONFIG - Syntax Highlighting
-- ============================================================================

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

configs.setup({
  -- Install parsers for these languages
  ensure_installed = {
    "c",
    "go",
    "python",
    "javascript",
    "typescript",
    "java",
    "rust",
    "lua",
    "vim",
    "vimdoc",
    "markdown",
    "bash",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- Highlight
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  -- Indentation
  indent = {
    enable = true,
  },

  -- Incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})

-- Folding based on treesitter (optional, performance focused)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Don't fold by default
