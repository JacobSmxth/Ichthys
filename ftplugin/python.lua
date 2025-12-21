local map = vim.keymap.set
local opts = { buffer = true, silent = true }

map("n", "<leader>cr", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  vim.cmd(string.format("TermExec cmd='clear && python3 %s'", file))
end, vim.tbl_extend("force", opts, { desc = "Python: Run file" }))

map("n", "<leader>ct", function()
  vim.cmd("w")
  vim.cmd("TermExec cmd='clear && python3 -m pytest'")
end, vim.tbl_extend("force", opts, { desc = "Python: Run pytest" }))

map("n", "<leader>cT", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  vim.cmd(string.format("TermExec cmd='clear && python3 -m pytest %s -v'", file))
end, vim.tbl_extend("force", opts, { desc = "Python: Run pytest on file" }))

map("n", "<leader>ci", function()
  vim.cmd("TermExec cmd='clear && pip install -r requirements.txt'")
end, vim.tbl_extend("force", opts, { desc = "Python: pip install requirements" }))

map("n", "<leader>cv", function()
  vim.cmd("TermExec cmd='clear && python3 -m venv .venv && source .venv/bin/activate'")
end, vim.tbl_extend("force", opts, { desc = "Python: Create venv" }))

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "Python: Format (ruff)" }))

map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Python: Code action" }))
