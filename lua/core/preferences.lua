local M = {}

M.config_dir = vim.fn.stdpath("config")
M.preferences_file = M.config_dir .. "/.preferences"

M.defaults = {
  mouse = "false",
  ollama_model = "qwen3-coder:30b",
}

function M.read()
  local prefs = vim.deepcopy(M.defaults)

  local file = io.open(M.preferences_file, "r")
  if file then
    for line in file:lines() do
      local key, value = line:match("^([^=]+)=(.+)$")
      if key and value then
        prefs[vim.trim(key)] = vim.trim(value)
      end
    end
    file:close()
  end

  return prefs
end

function M.write(prefs)
  local file = io.open(M.preferences_file, "w")
  if not file then
    vim.notify("Failed to write preferences file", vim.log.levels.ERROR)
    return false
  end

  for key, value in pairs(prefs) do
    file:write(key .. "=" .. value .. "\n")
  end

  file:close()
  return true
end

function M.get(key)
  local prefs = M.read()
  return prefs[key]
end

function M.set(key, value)
  local prefs = M.read()
  prefs[key] = value
  return M.write(prefs)
end

function M.check_ollama()
  local handle = io.popen("command -v ollama 2>/dev/null")
  if not handle then
    return false
  end

  local result = handle:read("*a")
  handle:close()

  return result and result ~= ""
end

return M
