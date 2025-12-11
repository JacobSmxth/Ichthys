-- Gradle task template for Overseer

return {
  name = "gradle",
  builder = function()
    local tasks = {
      { name = "bootRun", cmd = { "./gradlew", "bootRun" } },
      { name = "build", cmd = { "./gradlew", "build" } },
      { name = "clean", cmd = { "./gradlew", "clean" } },
      { name = "test", cmd = { "./gradlew", "test" } },
      { name = "bootJar", cmd = { "./gradlew", "bootJar" } },
      { name = "dependencies", cmd = { "./gradlew", "dependencies" } },
      { name = "tasks", cmd = { "./gradlew", "tasks" } },
    }

    return {
      name = "Select Gradle task",
      params = {
        task = {
          type = "enum",
          choices = vim.tbl_map(function(t)
            return t.name
          end, tasks),
          default = "bootRun",
        },
      },
      builder = function(params)
        local selected = vim.tbl_filter(function(t)
          return t.name == params.task
        end, tasks)[1]

        return {
          cmd = selected.cmd,
          components = {
            { "on_output_quickfix", open = false },
            "on_result_diagnostics",
            "default",
          },
        }
      end,
    }
  end,
  condition = {
    filetype = { "java" },
    callback = function()
      return vim.fn.filereadable("build.gradle") == 1
        or vim.fn.filereadable("build.gradle.kts") == 1
        or vim.fn.filereadable("gradlew") == 1
    end,
  },
}
