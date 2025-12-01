-- lua/plugins/configs/dev-dash.lua
-- Developer Dashboard - Quick project overview

local M = {}

local function get_git_info()
  local lines = {}

  -- Current branch
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  if branch ~= "" then
    table.insert(lines, "Branch: " .. branch)

    -- Ahead/behind
    local ahead_behind = vim.fn.system("git rev-list --left-right --count HEAD...@{u} 2>/dev/null"):gsub("\n", "")
    if ahead_behind ~= "" then
      local ahead, behind = ahead_behind:match("(%d+)%s+(%d+)")
      if ahead and behind then
        local status = ""
        if tonumber(ahead) > 0 then status = status .. "↑" .. ahead .. " " end
        if tonumber(behind) > 0 then status = status .. "↓" .. behind end
        if status ~= "" then
          table.insert(lines, "Sync: " .. status)
        else
          table.insert(lines, "Sync: up to date")
        end
      end
    end

    -- Last commit
    local last_commit = vim.fn.system("git log -1 --format='%h - %s' 2>/dev/null"):gsub("\n", "")
    if last_commit ~= "" then
      table.insert(lines, "Last: " .. last_commit)
    end

    -- Time since last commit
    local commit_time = vim.fn.system("git log -1 --format='%ar' 2>/dev/null"):gsub("\n", "")
    if commit_time ~= "" then
      table.insert(lines, "When: " .. commit_time)
    end

    table.insert(lines, "")

    -- Git status
    local git_status = vim.fn.systemlist("git status --short 2>/dev/null")
    if #git_status > 0 then
      table.insert(lines, "Changes:")
      for _, line in ipairs(git_status) do
        table.insert(lines, "  " .. line)
      end
    else
      table.insert(lines, "No changes")
    end
  else
    table.insert(lines, "Not a git repository")
  end

  return lines
end

local function get_project_info()
  local lines = {}
  local cwd = vim.fn.getcwd()

  table.insert(lines, "Path: " .. vim.fn.fnamemodify(cwd, ":~"))
  table.insert(lines, "")

  -- Detect language versions
  local java_version = vim.fn.system("java -version 2>&1 | head -1"):gsub("\n", "")
  if java_version:match("version") then
    local version = java_version:match('"([^"]+)"')
    if version then
      table.insert(lines, "Java: " .. version)
    end
  end

  local go_version = vim.fn.system("go version 2>/dev/null"):gsub("\n", "")
  if go_version:match("go version") then
    local version = go_version:match("go(%S+)")
    if version then
      table.insert(lines, "Go: " .. version)
    end
  end

  local node_version = vim.fn.system("node --version 2>/dev/null"):gsub("\n", "")
  if node_version ~= "" then
    table.insert(lines, "Node: " .. node_version)
  end

  local python_version = vim.fn.system("python3 --version 2>/dev/null"):gsub("\n", "")
  if python_version:match("Python") then
    local version = python_version:match("Python%s+(%S+)")
    if version then
      table.insert(lines, "Python: " .. version)
    end
  end

  return lines
end

local function get_lsp_info()
  local lines = {}

  -- Get LSP clients attached to current buffer
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if #clients == 0 then
    table.insert(lines, "No LSP clients attached")
  else
    table.insert(lines, "Active LSP Servers:")
    for _, client in ipairs(clients) do
      local status = "ready"
      -- Check if client is still initializing
      if client.initialized == false then
        status = "initializing"
      end
      table.insert(lines, string.format("  %s (%s)", client.name, status))
    end
  end

  return lines
end

local function get_spring_boot_info()
  local lines = {}
  local cwd = vim.fn.getcwd()

  -- Check if this is a Spring Boot project
  local is_spring = false
  local build_gradle = cwd .. "/build.gradle"
  if vim.fn.filereadable(build_gradle) == 1 then
    local content = table.concat(vim.fn.readfile(build_gradle), "\n")
    if content:match("spring%-boot") then
      is_spring = true
    end
  end

  if not is_spring then
    return nil -- Don't show this section if not Spring Boot
  end

  table.insert(lines, "Spring Boot Project Detected")
  table.insert(lines, "")

  -- Check for active profile
  local profile = os.getenv("SPRING_PROFILES_ACTIVE") or "default"
  table.insert(lines, "Profile: " .. profile)

  -- Try to read application.properties for port
  local props_file = cwd .. "/src/main/resources/application.properties"
  if vim.fn.filereadable(props_file) == 1 then
    local props = vim.fn.readfile(props_file)
    for _, line in ipairs(props) do
      local port = line:match("server%.port%s*=%s*(%d+)")
      if port then
        table.insert(lines, "Port: " .. port)

        -- Check if port is in use (app running) - Linux/macOS compatible
        local port_check_cmd = vim.fn.has("linux") == 1
          and "lsof -i:" .. port .. " 2>/dev/null | grep LISTEN"
          or "lsof -nP -iTCP:" .. port .. " -sTCP:LISTEN 2>/dev/null"

        local port_check = vim.fn.system(port_check_cmd)
        if port_check ~= "" then
          table.insert(lines, "Status: Running")
        else
          table.insert(lines, "Status: Stopped")
        end
        break
      end
    end

    -- Check for datasource URL
    for _, line in ipairs(props) do
      local db_url = line:match("spring%.datasource%.url%s*=%s*(.+)")
      if db_url then
        table.insert(lines, "Database: " .. db_url)
        break
      end
    end
  end

  return lines
end

local function get_diagnostics_info()
  local lines = {}
  local diagnostics = vim.diagnostic.get()

  local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }
  local by_severity = { ERROR = {}, WARN = {}, INFO = {}, HINT = {} }

  for _, diag in ipairs(diagnostics) do
    local severity = vim.diagnostic.severity[diag.severity]
    counts[severity] = counts[severity] + 1
    table.insert(by_severity[severity], diag)
  end

  table.insert(lines, string.format("Errors: %d | Warnings: %d | Info: %d | Hints: %d",
    counts.ERROR, counts.WARN, counts.INFO, counts.HINT))
  table.insert(lines, "")

  -- Show top 10 errors
  if counts.ERROR > 0 then
    table.insert(lines, "Top Errors:")
    for i, diag in ipairs(by_severity.ERROR) do
      if i > 10 then break end
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(diag.bufnr), ":t")
      table.insert(lines, string.format("  %s:%d - %s", filename, diag.lnum + 1, diag.message))
    end
    table.insert(lines, "")
  end

  -- Show top 10 warnings
  if counts.WARN > 0 then
    table.insert(lines, "Top Warnings:")
    for i, diag in ipairs(by_severity.WARN) do
      if i > 10 then break end
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(diag.bufnr), ":t")
      table.insert(lines, string.format("  %s:%d - %s", filename, diag.lnum + 1, diag.message))
    end
  end

  if counts.ERROR == 0 and counts.WARN == 0 then
    table.insert(lines, "No issues found")
  end

  return lines
end

local function get_todos()
  local lines = {}

  -- Get current working directory (project root or current directory)
  local cwd = vim.fn.getcwd()

  -- Find TODO/FIXME/HACK/NOTE comments in current directory only
  local todo_results = vim.fn.systemlist(
    string.format("cd %s && rg --no-heading --line-number '(TODO|FIXME|HACK|NOTE|XXX|BUG):' . 2>/dev/null | head -20", vim.fn.shellescape(cwd))
  )

  if #todo_results > 0 then
    table.insert(lines, string.format("Found %d todo item(s):", math.min(#todo_results, 20)))
    table.insert(lines, "")
    for _, line in ipairs(todo_results) do
      -- Format: filename:line:content
      local file, lnum, content = line:match("^([^:]+):(%d+):(.*)$")
      if file and lnum and content then
        -- Shorten filename relative to cwd
        file = vim.fn.fnamemodify(file, ":~:.")
        -- Trim whitespace and extract just the TODO text
        content = content:gsub("^%s+", ""):gsub("%s+$", "")
        table.insert(lines, string.format("  [%s:%s] %s", file, lnum, content))
      end
    end
  else
    table.insert(lines, "No TODOs found")
  end

  return lines
end

local function get_system_info()
  local lines = {}
  local is_linux = vim.fn.has("linux") == 1
  local is_mac = vim.fn.has("mac") == 1

  -- Try to get system info (Linux-specific)
  local uname = vim.fn.system("uname -sr 2>/dev/null"):gsub("\n", "")
  if uname ~= "" then
    table.insert(lines, "System: " .. uname)
  end

  -- Memory info (OS-specific)
  if is_linux then
    local mem_info = vim.fn.systemlist("free -h 2>/dev/null | grep Mem")
    if #mem_info > 0 then
      local mem_line = mem_info[1]
      local total, used = mem_line:match("Mem:%s+(%S+)%s+(%S+)")
      if total and used then
        table.insert(lines, string.format("Memory: %s / %s", used, total))
      end
    end
  elseif is_mac then
    -- macOS doesn't have 'free' command, skip or use alternative
    local mem = vim.fn.system("vm_stat 2>/dev/null | grep 'Pages free'"):gsub("\n", "")
    if mem ~= "" then
      table.insert(lines, "Memory: (use Activity Monitor for details)")
    end
  end

  -- CPU load (OS-specific)
  if is_linux then
    local load = vim.fn.system("cat /proc/loadavg 2>/dev/null"):gsub("\n", "")
    if load ~= "" then
      local load1, load5, load15 = load:match("(%S+)%s+(%S+)%s+(%S+)")
      if load1 then
        table.insert(lines, string.format("Load: %s (1m) %s (5m) %s (15m)", load1, load5, load15))
      end
    end
  elseif is_mac then
    local load = vim.fn.system("sysctl -n vm.loadavg 2>/dev/null"):gsub("\n", "")
    if load ~= "" then
      table.insert(lines, "Load: " .. load)
    end
  end

  -- Disk usage for current directory (works on both Linux/macOS)
  local disk = vim.fn.system("df -h . 2>/dev/null | tail -1")
  if disk ~= "" then
    local usage, avail, percent = disk:match("%S+%s+%S+%s+(%S+)%s+(%S+)%s+(%S+)")
    if usage and avail and percent then
      table.insert(lines, string.format("Disk: %s used, %s available (%s)", usage, avail, percent))
    end
  end

  return lines
end

local function render_content()
  local content = {}

  table.insert(content, "╔════════════════════════════════════════════════════════╗")
  table.insert(content, "║              DEVELOPER DASHBOARD                      ║")
  table.insert(content, "╚════════════════════════════════════════════════════════╝")
  table.insert(content, "")

  -- Git section
  table.insert(content, "┌─ GIT ────────────────────────────────────────────────┐")
  for _, line in ipairs(get_git_info()) do
    table.insert(content, "│ " .. line)
  end
  table.insert(content, "└──────────────────────────────────────────────────────┘")
  table.insert(content, "")

  -- Project Info section
  table.insert(content, "┌─ PROJECT INFO ───────────────────────────────────────┐")
  for _, line in ipairs(get_project_info()) do
    table.insert(content, "│ " .. line)
  end
  table.insert(content, "└──────────────────────────────────────────────────────┘")
  table.insert(content, "")

  -- LSP section
  table.insert(content, "┌─ LSP ────────────────────────────────────────────────┐")
  for _, line in ipairs(get_lsp_info()) do
    table.insert(content, "│ " .. line)
  end
  table.insert(content, "└──────────────────────────────────────────────────────┘")
  table.insert(content, "")

  -- Spring Boot section (conditional)
  local spring_info = get_spring_boot_info()
  if spring_info then
    table.insert(content, "┌─ SPRING BOOT ────────────────────────────────────────┐")
    for _, line in ipairs(spring_info) do
      table.insert(content, "│ " .. line)
    end
    table.insert(content, "└──────────────────────────────────────────────────────┘")
    table.insert(content, "")
  end

  -- Diagnostics section
  table.insert(content, "┌─ DIAGNOSTICS ────────────────────────────────────────┐")
  for _, line in ipairs(get_diagnostics_info()) do
    table.insert(content, "│ " .. line)
  end
  table.insert(content, "└──────────────────────────────────────────────────────┘")
  table.insert(content, "")

  -- TODOs section
  table.insert(content, "┌─ TODOs ──────────────────────────────────────────────┐")
  for _, line in ipairs(get_todos()) do
    table.insert(content, "│ " .. line)
  end
  table.insert(content, "└──────────────────────────────────────────────────────┘")
  table.insert(content, "")

  -- System section
  table.insert(content, "┌─ SYSTEM ─────────────────────────────────────────────┐")
  for _, line in ipairs(get_system_info()) do
    table.insert(content, "│ " .. line)
  end
  table.insert(content, "└──────────────────────────────────────────────────────┘")
  table.insert(content, "")
  table.insert(content, "Press 'q' to close | 'r' to refresh")

  return content
end

function M.open_dashboard()
  local bufname = "DevDash"

  -- Check if buffer already exists
  local existing_buf = vim.fn.bufnr(bufname)
  if existing_buf ~= -1 then
    -- Check if it's visible in any window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == existing_buf then
        -- Close it
        vim.api.nvim_win_close(win, false)
        return
      end
    end
  end

  -- Create new split
  vim.cmd("botright vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, bufname)

  -- Set buffer options
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("filetype", "devdash", { buf = buf })

  -- Set window options
  vim.api.nvim_set_option_value("number", false, { win = win })
  vim.api.nvim_set_option_value("relativenumber", false, { win = win })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = win })
  vim.api.nvim_set_option_value("wrap", false, { win = win })
  vim.api.nvim_win_set_width(win, 60)

  -- Render initial content
  local content = render_content()
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  -- Set up keymaps
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, false)
  end, { buffer = buf, noremap = true, silent = true })

  vim.keymap.set("n", "r", function()
    M.refresh_dashboard(buf, win)
  end, { buffer = buf, noremap = true, silent = true })

  -- Set up syntax highlighting
  vim.cmd([[
    syntax match DevDashHeader /^╔.*╗$/
    syntax match DevDashHeader /^║.*║$/
    syntax match DevDashHeader /^╚.*╝$/
    syntax match DevDashSection /^┌.*┐$/
    syntax match DevDashSection /^└.*┘$/
    syntax match DevDashBorder /^│/
    syntax match DevDashError /Errors: \d\+/
    syntax match DevDashWarning /Warnings: \d\+/
    syntax match DevDashSuccess /No issues found/
    syntax match DevDashSuccess /up to date/
    syntax match DevDashTodo /TODO:/
    syntax match DevDashTodo /FIXME:/
    syntax match DevDashTodo /HACK:/
    syntax match DevDashTodo /NOTE:/
    syntax match DevDashTodo /XXX:/
    syntax match DevDashTodo /BUG:/

    highlight default link DevDashHeader Title
    highlight default link DevDashSection Special
    highlight default link DevDashBorder Comment
    highlight default link DevDashError DiagnosticError
    highlight default link DevDashWarning DiagnosticWarn
    highlight default link DevDashSuccess DiagnosticOk
    highlight default link DevDashTodo Todo
  ]])
end

function M.refresh_dashboard(buf, win)
  -- Validate buffer and window still exist
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
    return
  end

  -- Re-render content
  local content = render_content()
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

return M
