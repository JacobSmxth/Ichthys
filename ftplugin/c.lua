-- ============================================================================
-- C FTPLUGIN - Language-specific settings and keybindings
-- ============================================================================

local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- <leader>cc - Compile current C file
map("n", "<leader>cc", function()
  vim.cmd("w") -- Save first
  vim.cmd("!gcc -Wall -Wextra -o %:r %")
end, vim.tbl_extend("force", opts, { desc = "C: Compile with gcc" }))

-- <leader>cr - Compile and run current C file
map("n", "<leader>cr", function()
  vim.cmd("w") -- Save first
  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")
  vim.cmd(string.format("TermExec cmd='gcc -Wall -Wextra -o %s %s && ./%s'", output, file, output))
end, vim.tbl_extend("force", opts, { desc = "C: Compile and run" }))

-- <leader>cd - Compile with debug symbols
map("n", "<leader>cd", function()
  vim.cmd("w") -- Save first
  vim.cmd("!gcc -Wall -Wextra -g -o %:r %")
end, vim.tbl_extend("force", opts, { desc = "C: Compile with debug symbols" }))

-- <leader>cx - Run compiled executable
map("n", "<leader>cx", function()
  local output = vim.fn.expand("%:r")
  vim.cmd(string.format("TermExec cmd='./%s'", output))
end, vim.tbl_extend("force", opts, { desc = "C: Run compiled executable" }))

-- <leader>cm - Compile with Makefile (if exists)
map("n", "<leader>cm", function()
  local makefile_exists = vim.fn.filereadable("Makefile") == 1 or vim.fn.filereadable("makefile") == 1
  if makefile_exists then
    vim.cmd("TermExec cmd='make'")
  else
    vim.notify("No Makefile found in current directory", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "C: Build with make" }))

-- <leader>cM - Clean make build
map("n", "<leader>cM", function()
  local makefile_exists = vim.fn.filereadable("Makefile") == 1 or vim.fn.filereadable("makefile") == 1
  if makefile_exists then
    vim.cmd("TermExec cmd='make clean'")
  else
    vim.notify("No Makefile found in current directory", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "C: Clean make build" }))
