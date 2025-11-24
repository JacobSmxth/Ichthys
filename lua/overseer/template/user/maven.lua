-- Maven task template for overseer.nvim
return {
  name = "maven",
  builder = function()
    local maven_wrapper = vim.fn.filereadable("mvnw") == 1 and "./mvnw" or "mvn"

    return {
      cmd = { maven_wrapper },
      args = { "clean", "install" },
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "java", "kotlin" },
    callback = function()
      return vim.fn.filereadable("pom.xml") == 1
    end,
  },
  tags = { "build", "maven" },
  desc = "Run Maven build tasks",
  params = {
    task = {
      type = "enum",
      name = "Maven Phase/Goal",
      desc = "The Maven phase or goal to run",
      choices = {
        "clean",
        "compile",
        "test",
        "package",
        "verify",
        "install",
        "deploy",
        "clean install",
        "clean package",
        "clean test",
        "spring-boot:run",
        "dependency:tree",
        "versions:display-dependency-updates",
      },
      default = "clean install",
    },
    args = {
      type = "string",
      name = "Additional Arguments",
      desc = "Additional Maven arguments (e.g., -DskipTests)",
      optional = true,
      default = "",
    },
  },
  generator = function(params)
    local maven_wrapper = vim.fn.filereadable("mvnw") == 1 and "./mvnw" or "mvn"
    local task_args = vim.split(params.task, " ")

    if params.args and params.args ~= "" then
      vim.list_extend(task_args, vim.split(params.args, " "))
    end

    return {
      cmd = maven_wrapper,
      args = task_args,
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
      name = string.format("mvn %s", params.task),
    }
  end,
}
