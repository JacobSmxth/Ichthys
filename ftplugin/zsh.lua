if vim.bo.filetype ~= "zsh" then
  return
end

local map = vim.keymap.set
local opts = { buffer = true, silent = true }

map("n", "<leader>cr", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  vim.cmd(string.format("TermExec cmd='clear && zsh %s'", file))
end, vim.tbl_extend("force", opts, { desc = "Zsh: Run script" }))

map("n", "<leader>cs", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  vim.cmd(string.format("TermExec cmd='clear && source %s'", file))
end, vim.tbl_extend("force", opts, { desc = "Zsh: Source file" }))

map("n", "<leader>cc", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local result = vim.fn.system(string.format("zsh -n %s 2>&1", file))
  if vim.v.shell_error == 0 then
    vim.notify("Zsh syntax OK", vim.log.levels.INFO)
  else
    vim.notify("Zsh syntax errors:\n" .. result, vim.log.levels.ERROR)
  end
end, vim.tbl_extend("force", opts, { desc = "Zsh: Check syntax" }))

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "Zsh: Format" }))

map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Zsh: Code action" }))
