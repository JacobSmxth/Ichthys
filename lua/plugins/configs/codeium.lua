-- Codeium.vim AI completion configuration

-- Enable codeium by default
vim.g.codeium_enabled = true

-- Disable codeium's default Tab binding (we use it for cmp)
vim.g.codeium_no_map_tab = true

-- Disable default keybindings (we'll set our own)
vim.g.codeium_disable_bindings = 1

-- Toggle function
local function toggle_codeium()
  if vim.g.codeium_enabled then
    vim.g.codeium_enabled = false
    vim.cmd("CodeiumDisable")
    print("Codeium disabled")
  else
    vim.g.codeium_enabled = true
    vim.cmd("CodeiumEnable")
    print("Codeium enabled")
  end
end

-- Create toggle command
vim.api.nvim_create_user_command("CodeiumToggle", toggle_codeium, { desc = "Toggle Codeium autocomplete" })

-- Keybinding for toggle
vim.keymap.set("n", "<leader>ot", ":CodeiumToggle<CR>", { silent = true, desc = "Toggle Codeium" })

-- Ghost text keybindings
vim.keymap.set("i", "<C-y>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true, desc = "Accept Codeium suggestion" })

vim.keymap.set("i", "<M-l>", function()
  return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true, desc = "Next Codeium suggestion" })

vim.keymap.set("i", "<M-h>", function()
  return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true, silent = true, desc = "Previous Codeium suggestion" })

vim.keymap.set("i", "<C-x>", function()
  return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true, desc = "Clear Codeium suggestion" })
