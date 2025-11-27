local map = vim.keymap.set
local opts = { buffer = true, silent = true }

map("n", "<leader>cr", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  vim.cmd(string.format("TermExec cmd='clear && node %s'", file))
end, vim.tbl_extend("force", opts, { desc = "JS: Run with Node" }))

map("n", "<leader>ct", function()
  vim.cmd("w")
  vim.cmd("TermExec cmd='clear && npm test'")
end, vim.tbl_extend("force", opts, { desc = "JS: Run tests" }))

map("n", "<leader>cb", function()
  vim.cmd("TermExec cmd='clear && npm run build'")
end, vim.tbl_extend("force", opts, { desc = "JS: Build" }))

map("n", "<leader>cs", function()
  vim.cmd("TermExec cmd='clear && npm start'")
end, vim.tbl_extend("force", opts, { desc = "JS: Start dev server" }))

map("n", "<leader>ci", function()
  vim.cmd("TermExec cmd='clear && npm install'")
end, vim.tbl_extend("force", opts, { desc = "JS: npm install" }))

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "JS: Format" }))

map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "JS: Code action" }))
