local prefs = require("core.preferences")

local mouse_file = vim.fn.stdpath("config") .. "/.mouse"

if vim.fn.filereadable(mouse_file) == 1 then
  local content = vim.fn.readfile(mouse_file)[1]
  local mouse_value = "false"

  if content and content:lower():match("^%s*true%s*$") then
    mouse_value = "true"
  end

  prefs.set("mouse", mouse_value)
  vim.fn.delete(mouse_file)
  vim.notify("Migrated .mouse to .preferences", vim.log.levels.INFO)
end
