-- Maven task template for Overseer

return {
  name = "maven",
  builder = function()
    local tasks = {
      { name = "spring-boot:run", cmd = { "./mvnw", "spring-boot:run" } },
      { name = "clean install", cmd = { "./mvnw", "clean", "install" } },
      { name = "clean", cmd = { "./mvnw", "clean" } },
      { name = "test", cmd = { "./mvnw", "test" } },
      { name = "package", cmd = { "./mvnw", "package" } },
      { name = "dependency:tree", cmd = { "./mvnw", "dependency:tree" } },
      { name = "compile", cmd = { "./mvnw", "compile" } },
    }

    return {
      name = "Select Maven task",
      params = {
        task = {
          type = "enum",
          choices = vim.tbl_map(function(t)
            return t.name
          end, tasks),
          default = "spring-boot:run",
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
      return vim.fn.filereadable("pom.xml") == 1 or vim.fn.filereadable("mvnw") == 1
    end,
  },
}
