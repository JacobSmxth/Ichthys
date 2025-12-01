local M = {}

M.connections = {
  -- Example: dev = "postgresql://localhost:5432/dev_db",
  -- Add your own below
}

function M.connect(name)
  local url = M.connections[name]
  if url then
    vim.g.db = url
    vim.notify("Connected to " .. name, vim.log.levels.INFO)
  else
    vim.notify("Database not found: " .. name, vim.log.levels.WARN)
  end
end

return M
