if vim.bo.filetype ~= "bash" then
  return
end

local map = vim.keymap.set
local opts = { buffer = true, silent = true }

map("n", "<leader>cr", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  vim.cmd(string.format("TermExec cmd='clear && bash %s'", file))
end, vim.tbl_extend("force", opts, { desc = "Bash: Run script" }))

map("n", "<leader>cs", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  vim.cmd(string.format("TermExec cmd='clear && source %s'", file))
end, vim.tbl_extend("force", opts, { desc = "Bash: Source file" }))

map("n", "<leader>cc", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local result = vim.fn.system(string.format("bash -n %s 2>&1", file))
  if vim.v.shell_error == 0 then
    vim.notify("Bash syntax OK", vim.log.levels.INFO)
  else
    vim.notify("Bash syntax errors:\n" .. result, vim.log.levels.ERROR)
  end
end, vim.tbl_extend("force", opts, { desc = "Bash: Check syntax" }))

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "Bash: Format" }))

map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Bash: Code action" }))
