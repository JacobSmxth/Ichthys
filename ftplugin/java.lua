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

-- Verify jdtls binary exists
if vim.fn.executable(jdtls_bin) ~= 1 then
  vim.notify("jdtls not found at " .. jdtls_bin .. ". Run :Mason to install.", vim.log.levels.ERROR)
  return
end

local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Ensure workspace directory exists
if vim.fn.isdirectory(workspace_dir) == 0 then
  local ok = vim.fn.mkdir(workspace_dir, "p")
  if ok == 0 then
    vim.notify("Failed to create workspace directory: " .. workspace_dir, vim.log.levels.ERROR)
    return
  end
end

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
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
          "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
          "org.springframework.boot.test.context.SpringBootTest.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 5,
          staticStarThreshold = 3,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
      },
    },
  },
  init_options = {
    bundles = (function()
      local bundles = {}

      -- Spring Boot Tools (enhances Spring Boot support including JPA)
      local spring_boot_jars = vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/spring-boot-tools/*.jar", true), "\n")
      vim.list_extend(bundles, vim.tbl_filter(function(jar) return jar ~= "" end, spring_boot_jars))

      -- Java Debug Adapter
      local debug_jars = vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/*.jar", true), "\n")
      vim.list_extend(bundles, vim.tbl_filter(function(jar) return jar ~= "" end, debug_jars))

      -- Java Test Runner
      local test_jars = vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar", true), "\n")
      vim.list_extend(bundles, vim.tbl_filter(function(jar) return jar ~= "" end, test_jars))

      -- Debug: print bundle count
      vim.notify(string.format("Loaded %d jdtls extension bundles", #bundles), vim.log.levels.INFO)

      return bundles
    end)(),
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
  vim.ui.input({ prompt = "Spring Profile (leave empty for default): " }, function(profile)
    local cmd
    if profile and profile ~= "" then
      cmd = string.format("SPRING_PROFILES_ACTIVE=%s ./gradlew bootRun", profile)
    else
      cmd = "./gradlew bootRun"
    end
    vim.cmd(string.format("TermExec cmd='clear && cd %s && %s'", root_dir, cmd))
  end)
end, vim.tbl_extend("force", opts, { desc = "Java: Gradle bootRun (with profile)" }))

-- Spring Boot helpers
map("n", "<leader>cR", function()
  local dir = vim.fn.fnameescape(root_dir)
  vim.cmd(string.format("TermExec cmd='pkill -f bootRun; sleep 1 && cd %s && ./gradlew bootRun'", dir))
end, vim.tbl_extend("force", opts, { desc = "Java: Restart Spring Boot" }))

map("n", "<leader>cL", function()
  local dir = vim.fn.fnameescape(root_dir)
  vim.cmd(string.format("TermExec cmd='tail -f %s/build/logs/spring.log'", dir))
end, vim.tbl_extend("force", opts, { desc = "Java: Tail Spring logs" }))

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

-- Hot reload (Spring DevTools)
map("n", "<leader>cH", function()
  vim.cmd("silent !touch " .. vim.fn.expand("%:p"))
  vim.notify("Triggered Spring DevTools hot reload", vim.log.levels.INFO)
end, vim.tbl_extend("force", opts, { desc = "Java: Hot Reload (DevTools)" }))

-- Navigate to application.properties/yml
map("n", "<leader>cp", function()
  local props = root_dir .. "/src/main/resources/application.properties"
  local yml = root_dir .. "/src/main/resources/application.yml"
  if vim.fn.filereadable(props) == 1 then
    vim.cmd("edit " .. props)
  elseif vim.fn.filereadable(yml) == 1 then
    vim.cmd("edit " .. yml)
  else
    vim.notify("No application.properties or application.yml found", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Java: Open application config" }))

-- Show dependencies
map("n", "<leader>cd", function()
  local gradle = vim.fn.filereadable(root_dir .. "/gradlew") == 1
  local maven = vim.fn.filereadable(root_dir .. "/mvnw") == 1
  local cmd
  if gradle then
    cmd = "./gradlew dependencies"
  elseif maven then
    cmd = "./mvnw dependency:tree"
  else
    vim.notify("No Gradle or Maven wrapper found", vim.log.levels.ERROR)
    return
  end
  vim.cmd(string.format("TermExec cmd='clear && cd %s && %s'", root_dir, cmd))
end, vim.tbl_extend("force", opts, { desc = "Java: Show dependencies" }))

-- Set up LSP keymaps immediately (will work once LSP attaches)
map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: Go to Definition" }))
map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: References" }))
map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Hover" }))
map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: Rename" }))
map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: Code Action" }))
map("n", "<leader>ci", require("jdtls").organize_imports, vim.tbl_extend("force", opts, { desc = "Java: Organize Imports" }))

-- Code lens (shows "Run" / "Debug" above main methods and tests)
map("n", "<leader>cl", vim.lsp.codelens.run, vim.tbl_extend("force", opts, { desc = "Java: Run Code Lens" }))

jdtls.start_or_attach(config)

-- Enable code lens and set up auto-refresh
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
  buffer = 0,
  callback = function()
    pcall(vim.lsp.codelens.refresh)
  end,
})

-- DAP configuration for Java debugging
local function setup_dap()
  local ok_dap, dap = pcall(require, "dap")
  if not ok_dap then
    return
  end

  dap.configurations.java = {
    {
      type = "java",
      request = "attach",
      name = "Debug (Attach) - Remote",
      hostName = "127.0.0.1",
      port = 5005,
    },
    {
      type = "java",
      request = "launch",
      name = "Debug (Launch) - Current File",
    },
  }
end

-- Set up DAP after a short delay to ensure jdtls is ready
vim.defer_fn(setup_dap, 200)
