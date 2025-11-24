-- Only run for cpp files
if vim.bo.filetype ~= "cpp" then
  return
end

local map = vim.keymap.set
local opts = { buffer = true, silent = true }

map("n", "<leader>cc", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")
  local result = vim.fn.system(string.format("g++ -Wall -Wextra -std=c++17 -o %s %s 2>&1", output, file))
  if vim.v.shell_error == 0 then
    vim.notify("Compiled successfully", vim.log.levels.INFO)
  else
    vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
  end
end, vim.tbl_extend("force", opts, { desc = "C++: Compile" }))

map("n", "<leader>cr", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")
  vim.cmd(string.format("TermExec cmd='clear && g++ -Wall -Wextra -std=c++17 -o %s %s 2>&1 && ./%s'", output, file, output))
end, vim.tbl_extend("force", opts, { desc = "C++: Compile and run" }))

map("n", "<leader>cd", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")
  local result = vim.fn.system(string.format("g++ -Wall -Wextra -std=c++17 -g -o %s %s 2>&1", output, file))
  if vim.v.shell_error == 0 then
    vim.notify("Compiled with debug symbols", vim.log.levels.INFO)
  else
    vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
  end
end, vim.tbl_extend("force", opts, { desc = "C++: Compile with debug" }))

map("n", "<leader>cx", function()
  local output = vim.fn.expand("%:r")
  vim.cmd(string.format("TermExec cmd='clear && ./%s'", output))
end, vim.tbl_extend("force", opts, { desc = "C++: Run executable" }))

map("n", "<leader>cm", function()
  local makefile_exists = vim.fn.filereadable("Makefile") == 1 or vim.fn.filereadable("makefile") == 1
  if makefile_exists then
    vim.cmd("TermExec cmd='clear && make'")
  else
    vim.notify("No Makefile found", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "C++: make" }))

map("n", "<leader>cv", function()
  local output = vim.fn.expand("%:r")
  vim.cmd(string.format("TermExec cmd='clear && valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./%s'", output))
end, vim.tbl_extend("force", opts, { desc = "C++: valgrind" }))

map("n", "<leader>cg", function()
  local output = vim.fn.expand("%:r")
  vim.cmd(string.format("TermExec cmd='clear && gdb ./%s'", output))
end, vim.tbl_extend("force", opts, { desc = "C++: GDB" }))

map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "C++: Code action" }))

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "C++: Format" }))
