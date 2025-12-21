-- Tool plugins: debugging, testing, refactoring, REST, terminal, search/replace

return {
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("plugins.configs.toggleterm")
    end,
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
      { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
      { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
      { "<leader>do", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
      { "<leader>dO", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
      { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", desc = "Toggle REPL" },
      { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", desc = "Run Last" },
      { "<leader>dt", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate" },
      { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Auto open/close UI
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      require("nvim-dap-virtual-text").setup()

      -- C/C++ debugging (codelldb)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      -- JavaScript/TypeScript debugging
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Python debugging (debugpy)
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            return "python3"
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch with arguments",
          program = "${file}",
          args = function()
            local args_str = vim.fn.input("Arguments: ")
            return vim.split(args_str, " ")
          end,
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            return "python3"
          end,
        },
      }
    end,
  },

  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },

  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>re", mode = { "x", "n" }, function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function" },
      { "<leader>rf", mode = "x", function() require("refactoring").refactor("Extract Function To File") end, desc = "Extract Function to File" },
      { "<leader>rv", mode = "x", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable" },
      { "<leader>ri", mode = { "x", "n" }, function() require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable" },
      { "<leader>rb", mode = "n", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block" },
      { "<leader>rbf", mode = "n", function() require("refactoring").refactor("Extract Block To File") end, desc = "Extract Block to File" },
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = { go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false },
        prompt_func_param_type = { go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false },
        printf_statements = {},
        print_var_statements = {},
      })
    end,
  },

  -- REST client
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "http",
    keys = {
      { "<leader>rr", "<cmd>Rest run<cr>", desc = "Run REST request" },
      { "<leader>rl", "<cmd>Rest run last<cr>", desc = "Run last REST request" },
    },
    config = function()
      require("rest-nvim").setup({
        result_split_horizontal = false,
        result_split_in_place = false,
        skip_ssl_verification = false,
        encode_url = true,
        highlight = { enabled = true, timeout = 150 },
        result = {
          show_url = true,
          show_http_info = true,
          show_headers = true,
          formatters = {
            json = "jq",
            html = function(body) return vim.fn.system({ "tidy", "-i", "-q", "-" }, body) end,
          },
        },
      })
    end,
  },

  -- Test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>nr", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>no", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
      { "<leader>nd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java"),
          require("neotest-jest")({
            jestCommand = "npm test --",
            env = { CI = true },
            cwd = function() return vim.fn.getcwd() end,
          }),
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
        },
        output = { enabled = true, open_on_run = false },
        quickfix = { enabled = false },
        status = { enabled = true, virtual_text = true, signs = true },
        icons = { passed = "✓", running = "●", failed = "✗", skipped = "○", unknown = "?" },
      })
    end,
  },

  { "rcasia/neotest-java", dependencies = { "nvim-neotest/neotest" } },
  { "nvim-neotest/neotest-jest", dependencies = { "nvim-neotest/neotest" } },
  { "nvim-neotest/neotest-python", dependencies = { "nvim-neotest/neotest" } },

  -- Find and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Find and Replace" },
      { "<leader>sw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Find and Replace (word)" },
      { "<leader>sv", function() require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end, mode = "v", desc = "Find and Replace (selection)" },
    },
    config = function()
      require("grug-far").setup({
        engine = "ripgrep",
        transient = true,
        keymaps = {
          replace = { n = "<localleader>r" },
          qflist = { n = "<localleader>q" },
          syncLocations = { n = "<localleader>s" },
          syncLine = { n = "<localleader>l" },
          close = { n = "<localleader>c" },
          historyOpen = { n = "<localleader>h" },
          historyAdd = { n = "<localleader>a" },
          refresh = { n = "<localleader>f" },
        },
      })
    end,
  },
}
