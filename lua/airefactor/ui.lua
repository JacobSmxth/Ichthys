local M = {}
function M.show_no_refactor(explanation)
  local lines = {
    "=== AI Refactor Analysis ===",
    "",
    "DECISION: No refactoring needed",
    "",
    "EXPLANATION:",
    explanation,
    "",
    "The code is already well-written!",
    "",
    "Press 'q' to close"
  }

  M.create_float_window(lines, "markdown", true)
end
function M.show_refactor(original, refactored, explanation, imports, changes, start_line, end_line, filetype)
  local buf_original = vim.api.nvim_create_buf(false, true)
  local buf_refactored = vim.api.nvim_create_buf(false, true)
  local buf_info = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_option(buf_original, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf_refactored, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf_info, "bufhidden", "wipe")
  local original_lines = vim.split(original, "\n")
  local refactored_lines = vim.split(refactored, "\n")

  local info_lines = {
    "=== AI Refactor Suggestions ===",
    "",
    "EXPLANATION:",
    explanation,
    "",
  }

  if imports ~= "None" and imports ~= "" then
    table.insert(info_lines, "IMPORTS NEEDED:")
    for line in imports:gmatch("[^\n]+") do
      table.insert(info_lines, "  " .. line)
    end
    table.insert(info_lines, "")
  end

  table.insert(info_lines, "CHANGES:")
  for _, change in ipairs(changes) do
    table.insert(info_lines, "  • " .. change)
  end
  table.insert(info_lines, "")
  table.insert(info_lines, "=== Actions ===")
  table.insert(info_lines, "")
  table.insert(info_lines, "  [a] Accept refactoring (replace selected code)")
  table.insert(info_lines, "  [r] Reject refactoring")
  table.insert(info_lines, "  [q] Close without changes")
  if imports ~= "None" and imports ~= "" then
    table.insert(info_lines, "")
    table.insert(info_lines, "NOTE: Remember to add imports manually if accepting!")
  end

  vim.api.nvim_buf_set_lines(buf_original, 0, -1, false, original_lines)
  vim.api.nvim_buf_set_lines(buf_refactored, 0, -1, false, refactored_lines)
  vim.api.nvim_buf_set_lines(buf_info, 0, -1, false, info_lines)

  vim.api.nvim_buf_set_option(buf_original, "filetype", filetype)
  vim.api.nvim_buf_set_option(buf_refactored, "filetype", filetype)
  vim.api.nvim_buf_set_option(buf_info, "filetype", "markdown")

  vim.api.nvim_buf_set_option(buf_original, "modifiable", false)
  vim.api.nvim_buf_set_option(buf_refactored, "modifiable", false)
  vim.api.nvim_buf_set_option(buf_info, "modifiable", false)

  local width = vim.o.columns
  local height = vim.o.lines
  local info_height = math.min(#info_lines + 2, math.floor(height * 0.3))
  local code_height = height - info_height - 4

  -- Create info window at top
  local win_info = vim.api.nvim_open_win(buf_info, true, {
    relative = "editor",
    width = width - 4,
    height = info_height,
    row = 1,
    col = 2,
    style = "minimal",
    border = "single",
    title = " Refactor Info ",
    title_pos = "center",
  })

  -- Create original code window (left)
  local code_width = math.floor((width - 6) / 2)
  local win_original = vim.api.nvim_open_win(buf_original, false, {
    relative = "editor",
    width = code_width,
    height = code_height,
    row = info_height + 3,
    col = 2,
    style = "minimal",
    border = "single",
    title = " Original Code ",
    title_pos = "center",
  })

  -- Create refactored code window (right)
  local win_refactored = vim.api.nvim_open_win(buf_refactored, false, {
    relative = "editor",
    width = code_width,
    height = code_height,
    row = info_height + 3,
    col = code_width + 4,
    style = "minimal",
    border = "single",
    title = " Refactored Code ",
    title_pos = "center",
  })

  -- Set window options
  vim.api.nvim_win_set_option(win_original, "number", true)
  vim.api.nvim_win_set_option(win_refactored, "number", true)
  vim.api.nvim_win_set_option(win_original, "relativenumber", false)
  vim.api.nvim_win_set_option(win_refactored, "relativenumber", false)

  -- Focus on info window
  vim.api.nvim_set_current_win(win_info)

  -- Store context for keymaps
  local context = {
    refactored = refactored,
    start_line = start_line,
    end_line = end_line,
    windows = { win_info, win_original, win_refactored },
    buffers = { buf_info, buf_original, buf_refactored },
  }

  -- Set up keymaps for accept/reject
  local function close_windows()
    for _, win in ipairs(context.windows) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
  end

  local function accept_refactor()
    -- Get the original buffer that was being edited
    local original_buf = vim.fn.bufnr("#")
    if original_buf == -1 then
      original_buf = vim.fn.bufnr("%")
    end

    -- Close windows first
    close_windows()

    -- Apply the refactored code
    vim.schedule(function()
      local refactored_lines = vim.split(context.refactored, "\n")
      vim.api.nvim_buf_set_lines(original_buf, context.start_line - 1, context.end_line, false, refactored_lines)
      vim.notify("Refactoring applied successfully!", vim.log.levels.INFO)
    end)
  end

  local function reject_refactor()
    close_windows()
    vim.notify("Refactoring rejected", vim.log.levels.INFO)
  end

  -- Set keymaps for all windows
  for _, buf in ipairs(context.buffers) do
    vim.keymap.set("n", "a", accept_refactor, { buffer = buf, silent = true, desc = "Accept refactoring" })
    vim.keymap.set("n", "r", reject_refactor, { buffer = buf, silent = true, desc = "Reject refactoring" })
    vim.keymap.set("n", "q", close_windows, { buffer = buf, silent = true, desc = "Close without changes" })
    vim.keymap.set("n", "<Esc>", close_windows, { buffer = buf, silent = true, desc = "Close without changes" })
  end
end

-- Create a simple floating window
function M.create_float_window(lines, filetype, centered)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", filetype)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end
  width = math.min(width + 4, vim.o.columns - 4)
  local height = math.min(#lines + 2, vim.o.lines - 4)

  local row = centered and math.floor((vim.o.lines - height) / 2) or 2
  local col = centered and math.floor((vim.o.columns - width) / 2) or 2

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
    title = " AI Refactor ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })

  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })

  return win, buf
end

return M
