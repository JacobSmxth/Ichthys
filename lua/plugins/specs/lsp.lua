-- LSP plugins: mason, lspconfig, language-specific servers, formatting

return {
  -- Mason (LSP/tool installer)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "single",
          icons = {
            package_installed = "+",
            package_pending = "->",
            package_uninstalled = "x",
          },
        },
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP Servers
          "jdtls",
          "clangd",
          "typescript-language-server",
          "html-lsp",
          "css-lsp",
          "emmet-ls",
          "lua-language-server",
          "bash-language-server",

          -- Formatters
          "google-java-format",
          "clang-format",
          "prettier",
          "eslint_d",
          "stylua",

          -- Linters
          "shellcheck",
          "markdownlint",

          -- Debuggers (DAP)
          "java-debug-adapter",
          "java-test",
          "codelldb",
          "js-debug-adapter",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("plugins.configs.lsp")
    end,
  },

  -- Java (enhanced)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- TypeScript (enhanced)
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          java = { "google-java-format" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          javascript = { "prettier", "eslint_d" },
          typescript = { "prettier", "eslint_d" },
          javascriptreact = { "prettier", "eslint_d" },
          typescriptreact = { "prettier", "eslint_d" },
          html = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
          sh = { "shellcheck" },
          bash = { "shellcheck" },
          zsh = { "shellcheck" },
        },
        formatters = {
          ["google-java-format"] = {
            command = vim.fn.stdpath("data") .. "/mason/bin/google-java-format",
          },
        },
      })
    end,
  },
}
