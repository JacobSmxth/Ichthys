-- Make task template for overseer.nvim
return {
  name = "make",
  builder = function()
    return {
      cmd = { "make" },
      args = {},
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "c", "cpp", "make" },
    callback = function()
      return vim.fn.filereadable("Makefile") == 1
        or vim.fn.filereadable("makefile") == 1
        or vim.fn.filereadable("GNUmakefile") == 1
    end,
  },
  tags = { "build", "make" },
  desc = "Run Make targets",
  params = {
    target = {
      type = "enum",
      name = "Make Target",
      desc = "The Make target to run",
      choices = function()
        -- Try to extract targets from Makefile
        local makefile = vim.fn.findfile("Makefile", ".;")
        if makefile == "" then
          makefile = vim.fn.findfile("makefile", ".;")
        end
        if makefile == "" then
          makefile = vim.fn.findfile("GNUmakefile", ".;")
        end

        if makefile == "" then
          return { "all", "clean", "install", "test", "build" }
        end

        local targets = {}
        local ok, lines = pcall(vim.fn.readfile, makefile)
        if not ok then
          return { "all", "clean", "install", "test", "build" }
        end

        for _, line in ipairs(lines) do
          -- Match lines that look like targets (name:)
          local target = line:match("^([%w_-]+):")
          if target and not vim.startswith(target, ".") then
            table.insert(targets, target)
          end
        end

        if #targets == 0 then
          return { "all", "clean", "install", "test", "build" }
        end

        table.sort(targets)
        return targets
      end,
      default = "all",
    },
    jobs = {
      type = "number",
      name = "Parallel Jobs",
      desc = "Number of parallel jobs (-j flag)",
      optional = true,
      default = 1,
    },
    args = {
      type = "string",
      name = "Additional Arguments",
      desc = "Additional Make arguments",
      optional = true,
      default = "",
    },
  },
  generator = function(params)
    local task_args = {}

    if params.target and params.target ~= "" then
      table.insert(task_args, params.target)
    end

    if params.jobs and params.jobs > 1 then
      table.insert(task_args, "-j" .. tostring(params.jobs))
    end

    if params.args and params.args ~= "" then
      vim.list_extend(task_args, vim.split(params.args, " "))
    end

    return {
      cmd = "make",
      args = task_args,
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
      name = string.format("make %s", params.target or "all"),
    }
  end,
}
