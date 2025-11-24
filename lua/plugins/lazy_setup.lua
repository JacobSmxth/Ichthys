-- Plugin setup

require("lazy").setup({
  -- Colorschemes
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
  },

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },

  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
  },

  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
  },

  -- Dashboard
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
            " ____       _____    ____   ____  _________________  ____   ____  _____      _____        ______  ",
            "|    |  ___|\\    \\  |    | |    |/                 \\|    | |    ||\\    \\    /    /|   ___|\\     \\ ",
            "|    | /    /\\    \\ |    | |    |\\______     ______|/    | |    || \\    \\  /    / |  |    |\\     \\",
            "|    ||    |  |    ||    |_|    |   \\( /    /  )/   |    |_|    ||  \\____\\/    /  /  |    |/____/|",
            "|    ||    |  |____||    .-.    |    ' |   |   '    |    .-.    | \\ |    /    /  /___|    \\|   | |",
            "|    ||    |   ____ |    | |    |      |   |        |    | |    |  \\|___/    /  /|    \\    \\___|/ ",
            "|    ||    |  |    ||    | |    |     /   //        |    | |    |      /    /  / |    |\\     \\    ",
            "|____||\\ ___\\/    /||____| |____|    /___//         |____| |____|     /____/  /  |\\ ___\\|_____|   ",
            "|    || |   /____/ ||    | |    |   |`   |          |    | |    |    |`    | /   | |    |     |   ",
            "|____| \\|___|    | /|____| |____|   |____|          |____| |____|    |_____|/     \\|____|_____|   ",
            "  \\(     \\( |____|/   \\(     )/       \\(              \\(     )/         )/           \\(    )/     ",
            "   '      '   )/       '     '         '               '     '          '             '    '      ",
            "              '                                                                                   ",
            "                               For the glory of God in all things                                 ",
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
          footer = { "Commit thy works unto the Lord, and thy thoughts shall be established. - Proverbs 16:3 KJV" },
        },
      })

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

  -- LSP Mason
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
          -- LSP Servers
          "jdtls",                      -- Java
          "clangd",                     -- C/C++
          "omnisharp",                  -- C#
          "gopls",                      -- Go
          "pyright",                    -- Python
          "typescript-language-server", -- TypeScript/JavaScript
          "html-lsp",                   -- HTML
          "css-lsp",                    -- CSS/SCSS
          "emmet-ls",                   -- Emmet
          "lua-language-server",        -- Lua
          "bash-language-server",       -- Bash/Zsh

          -- Formatters
          "google-java-format",         -- Java
          "clang-format",               -- C/C++
          "csharpier",                  -- C#
          "gofumpt",                    -- Go
          "goimports",                  -- Go
          "black",                      -- Python
          "isort",                      -- Python
          "prettier",                   -- JS/TS/HTML/CSS/SCSS
          "eslint_d",                   -- JS/TS linting
          "stylua",                     -- Lua

          -- Linters
          "ruff",                       -- Python
          "shellcheck",                 -- Bash/Zsh
          "markdownlint",               -- Markdown

          -- Debuggers (DAP)
          "java-debug-adapter",         -- Java
          "java-test",                  -- Java testing
          "codelldb",                   -- C/C++
          "netcoredbg",                 -- C#
          "delve",                      -- Go
          "debugpy",                    -- Python
          "js-debug-adapter",           -- JavaScript/TypeScript
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
      "nvimdev/lspsaga.nvim",
    },
    config = function()
      require("plugins.configs.lsp")
    end,
  },

  -- LSP UI enhancements
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup({
        ui = {
          border = "single",
          code_action = "",
        },
        lightbulb = {
          enable = false,
          sign = false,
          virtual_text = false,
        },
        symbol_in_winbar = {
          enable = false,
        },
        outline = {
          win_width = 40,
          auto_preview = false,
        },
      })

      -- Override native LSP keybindings with lspsaga
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          -- Replace with lspsaga equivalents
          map("n", "gh", "<cmd>Lspsaga hover_doc<cr>", "Hover documentation")
          map("n", "gd", "<cmd>Lspsaga goto_definition<cr>", "Go to definition")
          map("n", "gD", "<cmd>Lspsaga peek_definition<cr>", "Peek definition")
          map("n", "gr", "<cmd>Lspsaga finder<cr>", "LSP Finder (references/impl)")
          map("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", "Rename symbol")
          map("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", "Code action")
          map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Previous diagnostic")
          map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diagnostic")
          map("n", "<leader>lo", "<cmd>Lspsaga outline<cr>", "Toggle outline")
        end,
      })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- TypeScript enhanced support
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
          cs = { "csharpier" },
          go = { "goimports", "gofumpt" },
          python = { "isort", "black" },
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

  -- Codeium AI completion
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
      require("plugins.configs.codeium")
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
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
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local f = ls.function_node

      local lorem_words = {
        "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
        "sed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore",
        "magna", "aliqua", "enim", "ad", "minim", "veniam", "quis", "nostrud",
        "exercitation", "ullamco", "laboris", "nisi", "aliquip", "ex", "ea", "commodo",
        "consequat", "duis", "aute", "irure", "in", "reprehenderit", "voluptate",
        "velit", "esse", "cillum", "fugiat", "nulla", "pariatur", "excepteur", "sint",
        "occaecat", "cupidatat", "non", "proident", "sunt", "culpa", "qui", "officia",
        "deserunt", "mollit", "anim", "id", "est", "laborum"
      }

      local function generate_lorem(count)
        local words = {}
        for i = 1, count do
          table.insert(words, lorem_words[(i - 1) % #lorem_words + 1])
        end
        return table.concat(words, " ")
      end

      ls.add_snippets("all", {
        s("lorem10", f(function() return generate_lorem(10) end)),
        s("lorem20", f(function() return generate_lorem(20) end)),
        s("lorem50", f(function() return generate_lorem(50) end)),
        s("lorem100", f(function() return generate_lorem(100) end)),
        s("lorem200", f(function() return generate_lorem(200) end)),
        s("lorem500", f(function() return generate_lorem(500) end)),
      })
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },

  {
    "saadparwaiz1/cmp_luasnip",
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.configs.treesitter")
    end,
  },

  -- Telescope
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

  -- Undo tree with telescope
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>u", "<cmd>Telescope undo<cr>", desc = "Undo tree" },
    },
    config = function()
      require("telescope").load_extension("undo")
      require("telescope").setup({
        extensions = {
          undo = {
            use_delta = false,
            side_by_side = false,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
            mappings = {
              i = {
                ["<CR>"] = require("telescope-undo.actions").restore,
                ["<C-y>"] = require("telescope-undo.actions").yank_additions,
                ["<C-Y>"] = require("telescope-undo.actions").yank_deletions,
              },
              n = {
                ["<CR>"] = require("telescope-undo.actions").restore,
                ["<C-y>"] = require("telescope-undo.actions").yank_additions,
                ["<C-Y>"] = require("telescope-undo.actions").yank_deletions,
              },
            },
          },
        },
      })
    end,
  },

  -- Project session management
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_use_git_branch = true,
        session_lens = {
          prompt_title = "Sessions",
        },
      })

      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

      -- Suppress session messages immediately
      vim.opt.shortmess:append("F")
      local group = vim.api.nvim_create_augroup("AutoSessionMessages", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = { "AutoSessionRestored", "AutoSessionLoadPre", "AutoSessionSavePre" },
        callback = function()
          vim.cmd("echon ''")
          vim.opt.cmdheight = 0
        end,
      })
    end,
  },

  {
    "nvim-lua/plenary.nvim",
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("plugins.configs.nvimtree")
    end,
  },

  -- Oil.nvim (file explorer as a buffer)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = false,
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          sort = {
            { "type", "asc" },
            { "name", "asc" },
          },
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open Oil (float)" })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.configs.gitsigns")
    end,
  },

  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
    },
  },

  -- Mini.nvim modules
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup()
    end,
  },

  {
    "echasnovski/mini.comment",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mini.comment").setup({
        options = {
          custom_commentstring = nil,
        },
        mappings = {
          comment = "gc",
          comment_line = "gcc",
          comment_visual = "gc",
          textobject = "gc",
        },
      })
    end,
  },

  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
          update_n_lines = "sn",
        },
      })
    end,
  },

  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          delay = 100,
          animation = require("mini.indentscope").gen_animation.none(),
        },
      })
    end,
  },

  {
    "echasnovski/mini.icons",
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- Flash motion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      { "m", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "M", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- Harpoon (quick file navigation)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
    end,
  },


  -- TODO comments highlighting
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Auto close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Lorem Ipsum generator
  {
    "derektata/lorem.nvim",
  },

  -- Markdown preview
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = "markdown",
    opts = {
      heading = {
        enabled = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        width = "block",
        left_pad = 2,
        right_pad = 2,
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
    },
  },

  -- REST client
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      { "<leader>kr", "<cmd>lua require('kulala').run()<cr>", desc = "Run request" },
      { "<leader>kt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
      { "<leader>kc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
    },
    config = function()
      require("kulala").setup()
    end,
  },

  -- Treesitter context (sticky scroll)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 6,
    },
  },

  -- Code outline
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>a", "<cmd>AerialToggle<cr>", desc = "Toggle code outline" },
    },
    opts = {
      layout = {
        max_width = { 40, 0.2 },
        width = nil,
        min_width = 20,
      },
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },

  -- LSP progress UI
  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  -- Notification manager
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        background_colour = "#000000",
        fps = 60,
        icons = {
          DEBUG = "[D]",
          ERROR = "[E]",
          INFO = "[I]",
          TRACE = "[T]",
          WARN = "[W]",
        },
        level = 2,
        minimum_width = 50,
        render = "compact",
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true,
      })
      vim.notify = notify
    end,
  },

  -- Better UI for messages, cmdline and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            enabled = false,
          },
          hover = {
            enabled = true,
            silent = false,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline = { pattern = "^:", icon = ":", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
                { find = "Restored session" },
                { find = "lines yanked" },
              },
            },
            view = "mini",
          },
          {
            filter = {
              event = "notify",
              find = "No information available",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              kind = "",
              any = {
                { find = "Type number and <Enter>" },
                { find = "or click with the mouse" },
              },
            },
            opts = { skip = true },
          },
        },
      })
    end,
  },

  {
    "MunifTanjim/nui.nvim",
  },

  -- Trouble diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "modern",
        icons = {
          breadcrumb = ">",
          separator = "->",
          group = "+",
        },
        win = {
          border = "single",
          padding = { 1, 1 },
          wo = {
            winblend = 0,
          },
        },
        layout = {
          height = { min = 4, max = 15 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "center",
        },
      })

      -- Check for Ollama availability
      local prefs = require("core.preferences")
      local ollama_available = prefs.check_ollama()

      -- Register key group descriptions
      local keys = {
        -- Main leader groups
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>b", group = "Buffers" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>k", group = "Kulala (REST)" },
        { "<leader>l", group = "LSP/Lspsaga" },
        { "<leader>x", group = "Trouble/Diagnostics" },
        { "<leader>w", group = "Window" },
        { "<leader>o", group = "Options/Other" },
        { "<leader>c", group = "Code/Compile (filetype)" },
        { "<leader>t", group = "Tasks (Overseer)" },
        { "<leader>r", group = "Refactor" },

        -- Common LSP actions (lspsaga)
        { "<leader>ca", desc = "Code Action" },
        { "<leader>rn", desc = "Rename Symbol" },
        { "<leader>lo", desc = "Toggle Lspsaga Outline" },

        -- Git operations
        { "<leader>gg", desc = "Open Lazygit" },
        { "<leader>gb", desc = "Git Blame" },
        { "<leader>gd", desc = "Git Diff" },
        { "<leader>gs", desc = "Git Status" },

        -- Find operations
        { "<leader>ff", desc = "Find Files" },
        { "<leader>fg", desc = "Find in Files (Grep)" },
        { "<leader>fb", desc = "Find Buffers" },
        { "<leader>fs", desc = "Find Sessions" },
        { "<leader>fh", desc = "Find Help" },
        { "<leader>fo", desc = "Find Old Files" },
        { "<leader>fc", desc = "Find Commands" },
        { "<leader>fk", desc = "Find Keymaps" },
        { "<leader>fm", desc = "Find Man Pages" },

        -- Buffer operations
        { "<leader>bd", desc = "Delete Buffer" },
        { "<leader>bn", desc = "Next Buffer" },
        { "<leader>bp", desc = "Previous Buffer" },


        -- Tree/Outline
        { "<leader>e", desc = "Toggle File Explorer" },
        { "<leader>a", desc = "Toggle Code Outline" },

        -- Other
        { "<leader>u", desc = "Undo Tree" },
        { "<leader>/", desc = "Fuzzy Find in Buffer" },
        { "<leader>oi", desc = "Organize Imports (Java)" },
        { "<leader>ot", desc = "Toggle Codeium" },

        -- Dev Dashboard (standalone, DAP uses <leader>db, dc, etc.)
        { "<leader>d", desc = "Dev Dashboard" },

        -- Zen Mode
        { "<leader>z", desc = "Toggle Zen Mode" },
      }

      if ollama_available then
        table.insert(keys, { "<leader>ra", desc = "AI Refactor (Ollama)" })
      end

      wk.add(keys)
    end,
  },

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
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
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
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      require("nvim-dap-virtual-text").setup()

      -- Go debugging
      require("dap-go").setup()

      -- Python debugging
      require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

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

      -- C# debugging (netcoredbg)
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }

      -- JavaScript/TypeScript debugging (handled by vscode-js-debug in ftplugin)
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
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
  },

  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
  },

  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
  },

  -- Refactoring tools
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>re", mode = { "x", "n" }, function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function" },
      { "<leader>rf", mode = "x", function() require("refactoring").refactor("Extract Function To File") end, desc = "Extract Function to File" },
      { "<leader>rv", mode = "x", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable" },
      { "<leader>ri", mode = { "x", "n" }, function() require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable" },
      { "<leader>rb", mode = "n", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block" },
      { "<leader>rbf", mode = "n", function() require("refactoring").refactor("Extract Block To File") end, desc = "Extract Block to File" },
      { "<leader>rr", mode = { "x", "n" }, function() require("refactoring").select_refactor() end, desc = "Select Refactor" },
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      })
    end,
  },

  -- Dressing (UI for vim.ui.select/input - used by overseer, LSP, etc.)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          title_pos = "left",
          border = "single",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },
          win_options = {
            winblend = 0,
          },
        },
        select = {
          enabled = true,
          backend = { "telescope", "builtin" },
          telescope = require("telescope.themes").get_dropdown({
            borderchars = {
              prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
              results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
              preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            },
          }),
          builtin = {
            border = "single",
            relative = "editor",
            win_options = {
              winblend = 0,
            },
          },
          get_config = function(opts)
            -- Use telescope for code actions and overseer tasks
            if opts.kind == "codeaction" or opts.prompt and opts.prompt:match("Task") then
              return { backend = "telescope" }
            end
          end,
        },
      })
    end,
  },

  -- Task runner (unified UI for Gradle/Maven/NPM/Make)
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo" },
    dependencies = { "stevearc/dressing.nvim" },
    keys = {
      { "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Run Task" },
      { "<leader>tt", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
      { "<leader>ti", "<cmd>OverseerInfo<cr>", desc = "Task Info" },
      { "<leader>ta", "<cmd>OverseerTaskAction<cr>", desc = "Task Actions" },
    },
    config = function()
      require("overseer").setup({
        strategy = {
          "toggleterm",
          direction = "horizontal",
          open_on_start = true,
          quit_on_exit = "success",
        },
        templates = { "builtin", "user.gradle", "user.maven", "user.npm", "user.make" },
        form = {
          border = "single",
          win_opts = {
            winblend = 0,
            zindex = 60,
          },
        },
        task_editor = {
          border = "single",
          win_opts = {
            zindex = 60,
          },
        },
        confirm = {
          border = "single",
          win_opts = {
            zindex = 60,
          },
        },
        task_win = {
          win_opts = {
            winblend = 0,
          },
        },
        task_list = {
          direction = "bottom",
          min_height = 15,
          max_height = 25,
          default_detail = 1,
          bindings = {
            ["?"] = "ShowHelp",
            ["g?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["o"] = "Open",
            ["<C-v>"] = "OpenVsplit",
            ["<C-s>"] = "OpenSplit",
            ["<C-f>"] = "OpenFloat",
            ["<C-q>"] = "OpenQuickFix",
            ["p"] = "TogglePreview",
            ["<C-l>"] = "IncreaseDetail",
            ["<C-h>"] = "DecreaseDetail",
            ["L"] = "IncreaseAllDetail",
            ["H"] = "DecreaseAllDetail",
            ["["] = "DecreaseWidth",
            ["]"] = "IncreaseWidth",
            ["{"] = "PrevTask",
            ["}"] = "NextTask",
            ["<C-k>"] = "ScrollOutputUp",
            ["<C-j>"] = "ScrollOutputDown",
          },
        },
        component_aliases = {
          default = {
            { "display_duration", detail_level = 2 },
            "on_output_summarize",
            "on_exit_set_status",
            "on_complete_notify",
            "on_complete_dispose",
          },
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end,
  },

  -- Dev icons (kept for plugin compatibility, mini.icons used where possible)
  {
    "nvim-tree/nvim-web-devicons",
  },

  -- Zen Mode (distraction-free focus mode)
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = false },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = {
          enabled = false,
          font = "+4",
        },
      },
      on_open = function(win)
        -- Disable diagnostics in zen mode
        vim.diagnostic.disable()
      end,
      on_close = function()
        -- Re-enable diagnostics
        vim.diagnostic.enable()
      end,
    },
  },
}, {
  -- Lazy config
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
