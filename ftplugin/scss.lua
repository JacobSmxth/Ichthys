if vim.bo.filetype ~= "scss" then
  return
end

local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- SCSS-specific indentation
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "SCSS: Format" }))

map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "SCSS: Code action" }))

-- Compile SCSS to CSS (if sass is installed)
map("n", "<leader>cc", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r") .. ".css"
  vim.cmd(string.format("TermExec cmd='sass %s %s'", file, output))
end, vim.tbl_extend("force", opts, { desc = "SCSS: Compile to CSS" }))

-- Watch mode for SCSS compilation
map("n", "<leader>cw", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r") .. ".css"
  vim.cmd(string.format("TermExec cmd='sass --watch %s:%s'", file, output))
end, vim.tbl_extend("force", opts, { desc = "SCSS: Watch mode" }))
