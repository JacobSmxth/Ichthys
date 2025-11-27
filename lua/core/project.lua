-- lua/core/project.lua
-- Project type detection and environment setup

local M = {}

-- Detect project type based on marker files
function M.detect_project_type()
  local cwd = vim.fn.getcwd()
  local project_types = {}

  -- Check for Java/Spring
  if vim.fn.filereadable(cwd .. "/build.gradle") == 1 or vim.fn.filereadable(cwd .. "/pom.xml") == 1 then
    table.insert(project_types, "java")
    local build_gradle_content = vim.fn.filereadable(cwd .. "/build.gradle") == 1
      and table.concat(vim.fn.readfile(cwd .. "/build.gradle"), "\n") or ""
    if build_gradle_content:match("spring%-boot") then
      table.insert(project_types, "spring-boot")
    end
  end

  -- Check for Go
  if vim.fn.filereadable(cwd .. "/go.mod") == 1 then
    table.insert(project_types, "go")
  end

  -- Check for Node/TypeScript
  if vim.fn.filereadable(cwd .. "/package.json") == 1 then
    table.insert(project_types, "node")
  end

  -- Check for Rust
  if vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
    table.insert(project_types, "rust")
  end

  -- Check for C (Makefile with .c files)
  if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
    local c_files = vim.fn.glob(cwd .. "/**/*.c", false, true)
    if #c_files > 0 then
      table.insert(project_types, "c")
    end
  end

  -- Check for Python
  if vim.fn.filereadable(cwd .. "/requirements.txt") == 1 or
     vim.fn.filereadable(cwd .. "/setup.py") == 1 or
     vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    table.insert(project_types, "python")
  end

  return project_types
end

-- Verify environment for a project type
function M.verify_environment(project_type)
  local messages = {}

  if project_type == "java" then
    local java_home = os.getenv("JAVA_HOME")
    if not java_home then
      table.insert(messages, { level = "WARN", msg = "JAVA_HOME not set" })
    else
      table.insert(messages, { level = "INFO", msg = "JAVA_HOME: " .. java_home })
    end

    -- Check gradle daemon
    local gradle_running = vim.fn.system("pgrep -f 'GradleDaemon' 2>/dev/null")
    if gradle_running ~= "" then
      table.insert(messages, { level = "INFO", msg = "Gradle daemon running" })
    end
  end

  if project_type == "go" then
    local gopath = os.getenv("GOPATH")
    local goroot = os.getenv("GOROOT")
    if gopath then
      table.insert(messages, { level = "INFO", msg = "GOPATH: " .. gopath })
    end
    if goroot then
      table.insert(messages, { level = "INFO", msg = "GOROOT: " .. goroot })
    end
  end

  if project_type == "node" then
    local cwd = vim.fn.getcwd()
    if vim.fn.isdirectory(cwd .. "/node_modules") == 0 then
      table.insert(messages, { level = "WARN", msg = "node_modules not found. Run: npm install" })
    else
      table.insert(messages, { level = "INFO", msg = "node_modules present" })
    end
  end

  return messages
end

-- Setup project-specific configuration
function M.setup_project()
  local project_types = M.detect_project_type()

  if #project_types == 0 then
    return
  end

  -- Set buffer-local project type variable
  vim.b.project_types = project_types

  -- Verify environment for each detected type
  for _, ptype in ipairs(project_types) do
    local messages = M.verify_environment(ptype)
    for _, msg in ipairs(messages) do
      if msg.level == "WARN" then
        vim.notify(msg.msg, vim.log.levels.WARN)
      elseif msg.level == "INFO" then
        vim.notify(msg.msg, vim.log.levels.INFO)
      end
    end
  end

  -- Load project-specific .nvim.lua if it exists
  local cwd = vim.fn.getcwd()
  local project_config = cwd .. "/.nvim.lua"
  if vim.fn.filereadable(project_config) == 1 then
    vim.notify("Loading project-specific config: .nvim.lua", vim.log.levels.INFO)
    dofile(project_config)
  end
end

return M
