-- Quick project info floating popup
-- Shows git info + LSP status in a dismissable popup

local M = {}

function M.show()
  local lines = {}
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")

  table.insert(lines, " Project: " .. cwd)
  table.insert(lines, "")

  -- Git info
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  if branch ~= "" then
    table.insert(lines, " Branch: " .. branch)

    local ahead_behind = vim.fn.system("git rev-list --left-right --count HEAD...@{u} 2>/dev/null"):gsub("\n", "")
    if ahead_behind ~= "" then
      local ahead, behind = ahead_behind:match("(%d+)%s+(%d+)")
      if ahead and behind then
        local sync = ""
        if tonumber(ahead) > 0 then sync = sync .. "+" .. ahead .. " " end
        if tonumber(behind) > 0 then sync = sync .. "-" .. behind end
        if sync == "" then sync = "up to date" end
        table.insert(lines, "   Sync: " .. sync)
      end
    end

    local last_commit = vim.fn.system("git log -1 --format='%h %s' 2>/dev/null"):gsub("\n", "")
    if last_commit ~= "" then
      -- Truncate long commit messages
      if #last_commit > 50 then last_commit = last_commit:sub(1, 47) .. "..." end
      table.insert(lines, "   Last: " .. last_commit)
    end

    local status_count = vim.fn.system("git status --short 2>/dev/null | wc -l"):gsub("%s+", "")
    if status_count ~= "0" then
      table.insert(lines, "   Changes: " .. status_count .. " file(s)")
    else
      table.insert(lines, "   Changes: clean")
    end
  else
    table.insert(lines, " Git: not a repository")
  end

  table.insert(lines, "")

  -- LSP info
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    local names = {}
    for _, client in ipairs(clients) do
      table.insert(names, client.name)
    end
    table.insert(lines, " LSP: " .. table.concat(names, ", "))
  else
    table.insert(lines, " LSP: none attached")
  end

  -- Diagnostics summary
  local diag = vim.diagnostic.get()
  local err, warn = 0, 0
  for _, d in ipairs(diag) do
    if d.severity == vim.diagnostic.severity.ERROR then err = err + 1
    elseif d.severity == vim.diagnostic.severity.WARN then warn = warn + 1 end
  end
  table.insert(lines, " Diagnostics: " .. err .. " errors, " .. warn .. " warnings")
  table.insert(lines, "")
  table.insert(lines, " Press any key to close")

  -- Calculate window dimensions
  local width = 0
  for _, line in ipairs(lines) do
    if #line > width then width = #line end
  end
  width = math.min(width + 4, 60)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = #lines,
    row = math.floor((vim.o.lines - #lines) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "single",
    title = " Project Info ",
    title_pos = "center",
  })

  -- Close on any key press
  vim.keymap.set("n", "<Esc>", function()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end, { buffer = buf, nowait = true })

  -- Close on any other key too
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end,
  })

  -- Also close after pressing any key
  for _, key in ipairs({ "q", "<CR>", "<Space>" }) do
    vim.keymap.set("n", key, function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end, { buffer = buf, nowait = true })
  end
end

return M
