-- LSP configuration

local caps_ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
local capabilities = caps_ok and cmp_caps.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "LSP: Go to Definition")
  map("n", "gr", vim.lsp.buf.references, "LSP: References")
  map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
end

local function enable_lsp(name)
  vim.lsp.enable(name)
end

vim.lsp.config.clangd = {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
}
enable_lsp("clangd")

if vim.fn.executable("gopls") == 1 then
  vim.lsp.config.gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    capabilities = capabilities,
    on_attach = on_attach,
  }
  enable_lsp("gopls")
end

vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
}
enable_lsp("pyright")

vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
}
enable_lsp("ts_ls")

vim.lsp.config.rust_analyzer = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}
enable_lsp("rust_analyzer")

local function setup_java()
  local ok, jdtls = pcall(require, "jdtls")
  if not ok then
    vim.notify("nvim-jdtls not found", vim.log.levels.ERROR)
    return
  end

  local root_dir = require("jdtls.setup").find_root({
    "gradlew",
    "mvnw",
    "pom.xml",
    "build.gradle",
    ".git",
  })

  if not root_dir then
    vim.notify("jdtls: no project root found", vim.log.levels.WARN)
    return
  end

  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  local jdtls_bin = mason_bin .. "/jdtls"

  local workspace_dir = vim.fn.expand("~/.local/share/eclipse-workspaces/") .. vim.fn.fnamemodify(root_dir, ":p:h:t")

  local java_on_attach = function(_, bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "LSP: Go to Definition")
    map("n", "gr", vim.lsp.buf.references, "LSP: References")
    map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
    map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")

    map("n", "<leader>oi", function()
      require("jdtls").organize_imports()
    end, "Java: Organize Imports")
  end

  local config = {
    cmd = { jdtls_bin, "-data", workspace_dir },
    root_dir = root_dir,
    capabilities = capabilities,
    on_attach = java_on_attach,
    settings = {
      java = {
        configuration = {
          updateBuildConfiguration = "interactive",
          runtimes = {
            {
              name = "JavaSE-21",
              path = "/usr/lib/jvm/java-21-openjdk",
              default = true,
            },
          },
        },
        format = {
          enabled = false,
        },
        signatureHelp = {
          enabled = true,
        },
        contentProvider = {
          preferred = "fernflower",
        },
      },
    },
    init_options = {
      bundles = {},
    },
  }

  jdtls.start_or_attach(config)
end

-- Auto-start jdtls
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = setup_java,
})
