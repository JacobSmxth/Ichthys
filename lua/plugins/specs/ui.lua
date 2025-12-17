-- UI plugins: colorscheme, statusline, icons, prompts, keybinding hints

return {
  -- Colorscheme
  {
    "sainnhe/gruvbox-material",
    lazy = false,
  },

  -- Cursor animation
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end,
  },

  -- Dev icons
  {
    "nvim-tree/nvim-web-devicons",
  },

  {
    "echasnovski/mini.icons",
    lazy = true,
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- LSP progress UI
  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  -- Dressing (UI for vim.ui.select/input)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          title_pos = "center",
          border = "single",
          relative = "editor",
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
            if opts.kind == "codeaction" then
              return { backend = "telescope" }
            end
          end,
        },
      })
    end,
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
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>b", group = "Buffers" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>l", group = "LSP" },
        { "<leader>x", group = "Trouble/Diagnostics" },
        { "<leader>w", group = "Window" },
        { "<leader>o", group = "Options/Other" },
        { "<leader>c", group = "Code/Compile (filetype)" },
        { "<leader>r", group = "Refactor/REST" },
        { "<leader>n", group = "Neotest" },
        { "<leader>s", group = "Search/Replace" },
        { "<leader>q", group = "Session" },

        { "<leader>ca", desc = "Code Action" },
        { "<leader>rn", desc = "Rename Symbol" },
        { "<leader>ld", desc = "Show Diagnostic" },

        { "<leader>gg", desc = "Open Lazygit" },
        { "<leader>gb", desc = "Git Blame" },
        { "<leader>gd", desc = "Git Diff" },
        { "<leader>gs", desc = "Git Status" },

        { "<leader>ff", desc = "Find Files" },
        { "<leader>fg", desc = "Find in Files (Grep)" },
        { "<leader>fb", desc = "Find Buffers" },
        { "<leader>fh", desc = "Find Help" },
        { "<leader>fo", desc = "Find Old Files" },
        { "<leader>fc", desc = "Find Commands" },
        { "<leader>fk", desc = "Find Keymaps" },
        { "<leader>fm", desc = "Find Man Pages" },

        { "<leader>bd", desc = "Delete Buffer" },
        { "<leader>bn", desc = "Next Buffer" },
        { "<leader>bp", desc = "Previous Buffer" },

        { "<leader>e", desc = "Toggle File Explorer" },
        { "<leader>a", desc = "Toggle Code Outline" },
        { "<leader>z", desc = "Toggle Zen Mode" },

        { "<leader>/", desc = "Fuzzy Find in Buffer" },
        { "<leader>oi", desc = "Organize Imports (Java)" },

        { "<leader>d", group = "Debug (DAP)" },
      }

      if ollama_available then
        table.insert(keys, { "<leader>ra", desc = "AI Refactor (Ollama)" })
      end

      wk.add(keys)
    end,
  },
}
