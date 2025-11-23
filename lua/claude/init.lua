local api = require("claude.api")
local ui = require("claude.ui")

local M = {}

function M.explain(line1, line2)
  if not line1 or not line2 then
    vim.api.nvim_err_writeln("Explain command requires visual selection")
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
  local selected_text = table.concat(lines, "\n")

  if selected_text == "" then
    vim.api.nvim_err_writeln("No text selected")
    return
  end

  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == "" then
    filetype = "text"
  end

  local message = string.format("Explain\n```%s\n%s\n```", filetype, selected_text)

  api.call_claude(message, function(response)
    ui.show_response(response)
  end)
end

function M.guide(args)
  if not args or args == "" then
    vim.api.nvim_err_writeln("Guide command requires arguments")
    return
  end

  local message = "Guide " .. args

  api.call_claude(message, function(response)
    ui.show_response(response)
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("Explain", function(opts)
    M.explain(opts.line1, opts.line2)
  end, { range = true })

  vim.api.nvim_create_user_command("Guide", function(opts)
    M.guide(opts.args)
  end, { nargs = "+", complete = "file" })
end

return M
