-- Gradle task template for overseer.nvim
return {
  name = "gradle",
  builder = function()
    local gradle_wrapper = vim.fn.filereadable("gradlew") == 1 and "./gradlew" or "gradle"

    return {
      cmd = { gradle_wrapper },
      args = { "build" },
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
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
      choices = {
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
      },
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
