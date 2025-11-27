-- Gradle task template for overseer.nvim
return {
  name = "gradle",
  condition = {
    filetype = { "java", "kotlin", "groovy" },
    callback = function()
      return vim.fn.filereadable("build.gradle") == 1
        or vim.fn.filereadable("build.gradle.kts") == 1
        or vim.fn.filereadable("settings.gradle") == 1
        or vim.fn.filereadable("settings.gradle.kts") == 1
    end,
  },
  tags = { "build", "gradle" },
  desc = "Run Gradle build tasks",
  params = {
    task = {
      type = "enum",
      name = "Gradle Task",
      desc = "The Gradle task to run",
      choices = function()
        local gradle_wrapper = vim.fn.filereadable("gradlew") == 1 and "./gradlew" or "gradle"
        local default_tasks = {
          "build",
          "clean",
          "test",
          "assemble",
          "run",
          "bootRun",
          "check",
          "jar",
          "war",
          "tasks",
        }

        -- Try to get tasks from gradle
        local handle = io.popen(gradle_wrapper .. " tasks --all 2>/dev/null")
        if not handle then
          return default_tasks
        end

        local result = handle:read("*a")
        handle:close()

        if result == "" then
          return default_tasks
        end

        local tasks = {}
        local in_task_section = false

        for line in result:gmatch("[^\r\n]+") do
          -- Look for task lines (they start with task name followed by " - ")
          if line:match("^%s*$") or line:match("^%-%-%-") then
            in_task_section = true
          elseif in_task_section then
            local task_name = line:match("^([%w:]+)%s*%-")
            if task_name and not task_name:match(":") then
              table.insert(tasks, task_name)
            end
          end
        end

        -- If we found tasks, return them sorted, otherwise use defaults
        if #tasks > 0 then
          table.sort(tasks)
          return tasks
        else
          return default_tasks
        end
      end,
      default = "build",
    },
    args = {
      type = "string",
      name = "Additional Arguments",
      desc = "Additional Gradle arguments",
      optional = true,
      default = "",
    },
  },
  generator = function(params)
    local gradle_wrapper = vim.fn.filereadable("gradlew") == 1 and "./gradlew" or "gradle"
    local task_args = { params.task }

    if params.args and params.args ~= "" then
      vim.list_extend(task_args, vim.split(params.args, " "))
    end

    return {
      cmd = gradle_wrapper,
      args = task_args,
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
      name = string.format("gradle %s", params.task),
    }
  end,
}
