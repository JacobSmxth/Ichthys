local prefs = require("core.preferences")

if not prefs.check_ollama() then
  return
end

local airefactor = require("airefactor")
local model = prefs.get("ollama_model")

airefactor.setup({
  model = model,
  host = "http://localhost:11434",
  timeout = 60000,
})

vim.api.nvim_create_user_command("AIRefactor", function(opts)
  airefactor.refactor({
    line1 = opts.line1,
    line2 = opts.line2,
  })
end, {
  range = true,
  desc = "AI-powered code refactoring with Ollama",
})

vim.keymap.set("v", "<leader>ra", ":AIRefactor<CR>", { desc = "AI Refactor selected code" })
