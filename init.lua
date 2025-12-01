-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core config
require("core.migrate_preferences")
require("core.options")
require("core.mappings")
require("core.autocmds")

-- Plugins
require("plugins.lazy_setup")

-- Apply appearance (theme and font)
require("core.appearance").setup()

-- LSP attachment visibility (for debugging)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      -- Only show in debug mode to avoid spam
      if vim.g.lsp_debug then
        vim.notify(
          string.format("%s attached to buffer %d", client.name, args.buf),
          vim.log.levels.DEBUG
        )
      end
    end
  end,
})

-- Enable with: :lua vim.g.lsp_debug = true
-- Disable with: :lua vim.g.lsp_debug = false
