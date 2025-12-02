local M = {}

local function combine_flags(...)
  local flags = {}
  for _, flag in ipairs({ ... }) do
    if flag and flag ~= "" then
      table.insert(flags, flag)
    end
  end
  return table.concat(flags, " ")
end

function M.setup_compiled_lang(opts)
  if not opts or not opts.name or not opts.compiler then
    vim.notify("compile_utils: name and compiler are required", vim.log.levels.ERROR)
    return
  end

  local map = vim.keymap.set
  local keymap_opts = { buffer = true, silent = true }
  local base_flags = combine_flags(opts.flags or "-Wall -Wextra", opts.std_flag)

  local function get_paths()
    return vim.fn.expand("%"), vim.fn.expand("%:r")
  end

  local function build_compile_cmd(extra_flags)
    local file, output = get_paths()
    local flags = combine_flags(base_flags, extra_flags)
    return string.format("%s %s -o %s %s 2>&1", opts.compiler, flags, output, file), output
  end

  local function compile(extra_flags, success_msg, failure_msg)
    vim.cmd("w")
    local cmd = build_compile_cmd(extra_flags)
    local result = vim.fn.system(cmd)
    if vim.v.shell_error == 0 then
      vim.notify(success_msg or (opts.name .. " compiled successfully"), vim.log.levels.INFO)
    else
      vim.notify((failure_msg or (opts.name .. " compilation failed")) .. ":\n" .. result, vim.log.levels.ERROR)
    end
    return cmd
  end

  map("n", "<leader>cc", function()
    compile(nil, opts.name .. ": compiled successfully")
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": Compile" }))

  map("n", "<leader>cr", function()
    vim.cmd("w")
    local cmd, output = build_compile_cmd()
    vim.cmd(string.format("TermExec cmd='clear && %s && ./%s'", cmd, output))
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": Compile and run" }))

  map("n", "<leader>cd", function()
    compile("-g", opts.name .. ": Debug build ready")
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": Compile with debug" }))

  map("n", "<leader>cx", function()
    local _, output = get_paths()
    vim.cmd(string.format("TermExec cmd='clear && ./%s'", output))
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": Run executable" }))

  map("n", "<leader>cm", function()
    local has_makefile = vim.fn.filereadable("Makefile") == 1 or vim.fn.filereadable("makefile") == 1
    if has_makefile then
      vim.cmd("TermExec cmd='clear && make'")
    else
      vim.notify("No Makefile found", vim.log.levels.WARN)
    end
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": make" }))

  map("n", "<leader>cv", function()
    local _, output = get_paths()
    vim.cmd(string.format("TermExec cmd='clear && valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./%s'", output))
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": valgrind" }))

  map("n", "<leader>cg", function()
    local _, output = get_paths()
    vim.cmd(string.format("TermExec cmd='clear && gdb ./%s'", output))
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": GDB" }))

  map("n", "<leader>cf", function()
    vim.cmd("w")
    require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
    vim.cmd("e")
  end, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": Format" }))

  map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", keymap_opts, { desc = opts.name .. ": Code action" }))
end

return M
