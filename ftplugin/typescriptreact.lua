local map = vim.keymap.set
local opts = { buffer = true, silent = true }

map("n", "<leader>cr", function()
  vim.cmd("w")
  vim.cmd("TermExec cmd='clear && npm start'")
end, vim.tbl_extend("force", opts, { desc = "React TS: Start dev server" }))

map("n", "<leader>ct", function()
  vim.cmd("w")
  vim.cmd("TermExec cmd='clear && npm test'")
end, vim.tbl_extend("force", opts, { desc = "React TS: Run tests" }))

map("n", "<leader>cb", function()
  vim.cmd("TermExec cmd='clear && npm run build'")
end, vim.tbl_extend("force", opts, { desc = "React TS: Build" }))

map("n", "<leader>ci", function()
  vim.cmd("TermExec cmd='clear && npm install'")
end, vim.tbl_extend("force", opts, { desc = "React TS: npm install" }))

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "React TS: Format" }))

map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "React TS: Code action" }))
