vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

local map = vim.keymap.set
local opts = { buffer = true, silent = true }
local ok, jdtls = pcall(require, "jdtls")
if not ok then
  vim.notify("nvim-jdtls not installed", vim.log.levels.ERROR)
  return
end

local root_markers = { "gradlew", "build.gradle", "settings.gradle", "pom.xml", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if not root_dir or root_dir == "" then
  vim.notify("Java root not found", vim.log.levels.WARN)
  return
end

local jdtls_bin = vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local config = {
  cmd = { jdtls_bin, "-data", workspace_dir },
  root_dir = root_dir,
  settings = {
    java = {
      configuration = {
        runtimes = {
          { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk" },
          { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
        },
      },
      import = { gradle = { enabled = true } }, -- pull Gradle deps (Spring)
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
    },
  },
  init_options = {
    bundles = {
      -- Spring Boot Tools (optional, enhances Spring Boot support)
      -- Download from: https://github.com/spring-projects/sts4/releases
      -- Extract and place jars in ~/.local/share/nvim/spring-boot-tools/
      -- Provides: @Bean navigation, application.properties completion, Spring code actions
      -- vim.fn.glob(vim.fn.stdpath("data") .. "/spring-boot-tools/*.jar", true),
    },
  },
}

local function get_class_name()
  return vim.fn.expand("%:t:r")
end

-- Set up compile/run commands (always available)
map("n", "<leader>cc", function()
  vim.cmd("w")
  vim.cmd("!javac %")
end, vim.tbl_extend("force", opts, { desc = "Java: Compile" }))

map("n", "<leader>cr", function()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local class = get_class_name()
  vim.cmd(string.format("TermExec cmd='clear && javac \"%s\" 2>&1 && java %s'", file, class))
end, vim.tbl_extend("force", opts, { desc = "Java: Compile and run" }))

map("n", "<leader>cg", function()
  vim.cmd(string.format("TermExec cmd='clear && cd %s && ./gradlew bootRun'", root_dir))
end, vim.tbl_extend("force", opts, { desc = "Java: Gradle bootRun" }))

map("n", "<leader>cb", function()
  vim.cmd(string.format("TermExec cmd='clear && cd %s && ./gradlew build'", root_dir))
end, vim.tbl_extend("force", opts, { desc = "Java: Gradle build" }))

map("n", "<leader>ct", function()
  vim.cmd(string.format("TermExec cmd='clear && cd %s && ./gradlew test'", root_dir))
end, vim.tbl_extend("force", opts, { desc = "Java: Gradle test" }))

map("n", "<leader>cf", function()
  vim.cmd("w")
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  vim.cmd("e")
end, vim.tbl_extend("force", opts, { desc = "Java: Format" }))

jdtls.start_or_attach(config)

vim.api.nvim_create_autocmd("LspAttach", {
  buffer = 0,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.name ~= "jdtls" then
      return
    end

    map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to Definition" })
    map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: References" })
    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover" })
    map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code Action" })
    map("n", "<leader>ci", require("jdtls").organize_imports, { buffer = bufnr, desc = "Java: Organize Imports" })
  end,
})
