-- LSP configuration using Neovim 0.11+ native API

local caps_ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
local capabilities = caps_ok and cmp_caps.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gr", vim.lsp.buf.references, "Go to references")
  map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gh", vim.lsp.buf.hover, "Hover documentation")
  map("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

  -- Diagnostic navigation
  map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "<leader>ld", vim.diagnostic.open_float, "Show diagnostic")

  -- Enable inlay hints
  if client.supports_method("textDocument/inlayHint") then
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
  end
end

-- Helper to setup LSP server
local function setup_lsp(name, opts)
  opts = opts or {}
  opts.capabilities = capabilities
  opts.on_attach = on_attach

  vim.lsp.config[name] = opts
  vim.lsp.enable(name)
end

-- Clangd (C/C++)
setup_lsp("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
})

-- TypeScript/JavaScript - Handled by typescript-tools.nvim in lazy_setup.lua
-- setup_lsp("ts_ls", {
--   cmd = { "typescript-language-server", "--stdio" },
--   filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
--   root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
-- })

-- Lua (lazydev.nvim handles workspace/library setup)
setup_lsp("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      telemetry = { enable = false },
    },
  },
})

-- Bash/Zsh
setup_lsp("bashls", {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  root_markers = { ".git" },
})

-- HTML
setup_lsp("html", {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
})

-- CSS
setup_lsp("cssls", {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
})

-- Emmet
setup_lsp("emmet_ls", {
  cmd = { "emmet-ls", "--stdio" },
  filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", ".git" },
})

-- Python (basedpyright - enhanced pyright fork)
setup_lsp("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
      },
    },
  },
})

-- Ruff (Python linter/formatter LSP)
setup_lsp("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", ".git" },
})
