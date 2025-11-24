-- NPM task template for overseer.nvim
return {
  name = "npm",
  builder = function()
    return {
      cmd = { "npm" },
      args = { "run", "build" },
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
    callback = function()
      return vim.fn.filereadable("package.json") == 1
    end,
  },
  tags = { "build", "npm" },
  desc = "Run NPM scripts",
  params = {
    script = {
      type = "enum",
      name = "NPM Script",
      desc = "The NPM script to run",
      choices = function()
        local package_json_path = vim.fn.findfile("package.json", ".;")
        if package_json_path == "" then
          return { "build", "test", "start", "dev" }
        end

        local ok, package_json = pcall(vim.fn.readfile, package_json_path)
        if not ok then
          return { "build", "test", "start", "dev" }
        end

        local ok_decode, data = pcall(vim.fn.json_decode, table.concat(package_json, "\n"))
        if not ok_decode or not data.scripts then
          return { "build", "test", "start", "dev" }
        end

        local scripts = {}
        for script_name, _ in pairs(data.scripts) do
          table.insert(scripts, script_name)
        end

        table.sort(scripts)
        return scripts
      end,
      default = "build",
    },
    package_manager = {
      type = "enum",
      name = "Package Manager",
      desc = "Choose package manager",
      choices = {
        "npm",
        "yarn",
        "pnpm",
        "bun",
      },
      default = function()
        if vim.fn.filereadable("yarn.lock") == 1 then
          return "yarn"
        elseif vim.fn.filereadable("pnpm-lock.yaml") == 1 then
          return "pnpm"
        elseif vim.fn.filereadable("bun.lockb") == 1 then
          return "bun"
        else
          return "npm"
        end
      end,
    },
    args = {
      type = "string",
      name = "Additional Arguments",
      desc = "Additional arguments",
      optional = true,
      default = "",
    },
  },
  generator = function(params)
    local cmd = params.package_manager
    local task_args = {}

    if params.package_manager == "npm" then
      task_args = { "run", params.script }
    elseif params.package_manager == "yarn" then
      task_args = { params.script }
    elseif params.package_manager == "pnpm" then
      task_args = { "run", params.script }
    elseif params.package_manager == "bun" then
      task_args = { "run", params.script }
    end

    if params.args and params.args ~= "" then
      if params.package_manager == "npm" or params.package_manager == "pnpm" then
        table.insert(task_args, "--")
      end
      vim.list_extend(task_args, vim.split(params.args, " "))
    end

    return {
      cmd = cmd,
      args = task_args,
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
      name = string.format("%s run %s", params.package_manager, params.script),
    }
  end,
}
