-- ============================================================================
-- LAZY PLUGIN SETUP - Minimal Essential Plugins Only
-- ============================================================================

require("lazy").setup({
  -- ============================================================================
  -- DASHBOARD
  -- ============================================================================
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "",
            "",
            "   ▄████▄   ▒█████   ▓█████▄  ██▓ ███▄    █   ▄████",
            "  ▒██▀ ▀█  ▒██▒  ██▒ ▒██▀ ██▌▓██▒ ██ ▀█   █  ██▒ ▀█▒",
            "  ▒▓█    ▄ ▒██░  ██▒ ░██   █▌▒██▒▓██  ▀█ ██▒▒██░▄▄▄░",
            "  ▒▓▓▄ ▄██▒▒██   ██░ ░▓█▄   ▌░██░▓██▒  ▐▌██▒░▓█  ██▓",
            "  ▒ ▓███▀ ░░ ████▓▒░ ░▒████▓ ░██░▒██░   ▓██░░▒▓███▀▒",
            "  ░ ░▒ ▒  ░░ ▒░▒░▒░  ▒▒▓  ▒ ░▓  ░ ▒░   ▒ ▒   ░▒   ▒ ",
            "    ░  ▒     ░ ▒ ▒░  ░ ▒  ▒  ▒ ░░ ░░   ░ ▒░   ░   ░ ",
            "  ░        ░ ░ ░ ▒   ░ ░  ░  ▒ ░   ░   ░ ░  ░ ░   ░ ",
            "  ░ ░          ░ ░   ░  ░   ░     ░           ░   ",
            "   ░                        ░                      ",
            "              -- Coding for Christ --             ",
            "",
            "",
            "",
          },
          center = {
            { icon = " ", desc = "New File      ", key = "n", action = "ene | startinsert" },
            { icon = " ", desc = "Recent Files  ", key = "r", action = "Telescope oldfiles" },
            { icon = " ", desc = "Find File     ", key = "f", action = "Telescope find_files" },
            { icon = "󰍉 ", desc = "Grep Text     ", key = "g", action = "Telescope live_grep" },
            { icon = " ", desc = "Settings      ", key = "s", action = "edit $MYVIMRC" },
            { icon = " ", desc = "Quit Neovim   ", key = "q", action = "qa" },
          },
          footer = { "God is good. All the time." },
        },
      })

      -- Apply VSCode-style colors to dashboard after setup
      vim.cmd([[
        highlight DashboardHeader guifg=#4fc1ff ctermfg=81
        highlight DashboardCenter guifg=#cccccc ctermfg=252
        highlight DashboardFooter guifg=#858585 gui=italic ctermfg=102 cterm=italic
        highlight DashboardKey guifg=#007acc gui=bold ctermfg=31 cterm=bold
        highlight DashboardIcon guifg=#c586c0 ctermfg=175
        highlight DashboardDesc guifg=#d4d4d4 ctermfg=188
      ]])
    end,
  },

  -- ============================================================================
  -- LSP & MASON
  -- ============================================================================
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
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "jdtls",
          "clangd",
          -- "gopls",  -- Requires Go to be installed on system
          "pyright",
          "typescript-language-server",
          "rust-analyzer",
          -- Formatters
          "google-java-format",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("plugins.configs.lsp")
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- ============================================================================
  -- FORMATTING
  -- ============================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          java = { "google-java-format" },
          -- Add other formatters as needed
          python = { "isort", "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
        },
        formatters = {
          ["google-java-format"] = {
            command = vim.fn.stdpath("data") .. "/mason/bin/google-java-format",
          },
        },
        -- Format on save (optional - comment out if you don't want this)
        -- format_on_save = {
        --   timeout_ms = 500,
        --   lsp_fallback = true,
        -- },
      })
    end,
  },

  -- ============================================================================
  -- COMPLETION
  -- ============================================================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("plugins.configs.cmp")
    end,
  },

  {
    "hrsh7th/cmp-nvim-lsp",
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },

  {
    "saadparwaiz1/cmp_luasnip",
  },

  -- ============================================================================
  -- TREESITTER
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.configs.treesitter")
    end,
  },

  -- ============================================================================
  -- TELESCOPE
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("plugins.configs.telescope")
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  {
    "nvim-lua/plenary.nvim",
  },

  -- ============================================================================
  -- FILE EXPLORER
  -- ============================================================================
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("plugins.configs.nvimtree")
    end,
  },

  -- ============================================================================
  -- GIT
  -- ============================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.configs.gitsigns")
    end,
  },

  -- ============================================================================
  -- AUTOPAIRS
  -- ============================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.configs.autopairs")
    end,
  },

  -- ============================================================================
  -- COMMENTING
  -- ============================================================================
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },

  -- ============================================================================
  -- WHICH-KEY
  -- ============================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        preset = "classic",
        icons = {
          breadcrumb = ">",
          separator = "->",
          group = "+",
        },
        win = {
          border = "single",
        },
      })
    end,
  },

  -- ============================================================================
  -- TERMINAL
  -- ============================================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("plugins.configs.toggleterm")
    end,
  },

  -- ============================================================================
  -- STATUSLINE
  -- ============================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end,
  },

  -- ============================================================================
  -- WEB DEV ICONS (minimal)
  -- ============================================================================
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        default = true,
      })
    end,
  },
}, {
  -- Lazy.nvim config
  ui = {
    border = "single",
    icons = {
      cmd = "[CMD]",
      config = "[CFG]",
      event = "[EVT]",
      ft = "[FT]",
      init = "[INIT]",
      keys = "[KEY]",
      plugin = "[PLG]",
      runtime = "[RUN]",
      require = "[REQ]",
      source = "[SRC]",
      start = "[START]",
      task = "[TASK]",
      lazy = "[LAZY]",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
