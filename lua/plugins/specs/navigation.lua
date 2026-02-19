-- Navigation plugins: telescope, neo-tree, harpoon

return {
  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-treesitter/nvim-treesitter",
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
    lazy = true,
  },

  -- Neo-tree (file tree sidebar)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal current file in tree" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "single",
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = true,
        default_component_configs = {
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
          },
          modified = { symbol = "[+]" },
          git_status = {
            symbols = {
              added = "+",
              modified = "~",
              deleted = "x",
              renamed = "→",
              untracked = "?",
              ignored = "◌",
              unstaged = "○",
              staged = "●",
              conflict = "!",
            },
          },
        },
        window = {
          position = "left",
          width = 32,
          mappings = {
            -- Navigation
            ["l"] = "open",
            ["h"] = "close_node",
            ["<cr>"] = "open",
            ["<2-LeftMouse>"] = "open",
            ["s"] = "open_vsplit",
            ["S"] = "open_split",

            -- File operations
            ["a"] = { "add", config = { show_path = "relative" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["c"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["m"] = "move",

            -- Tree operations
            ["."] = "set_root",
            ["<bs>"] = "navigate_up",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["q"] = "close_window",

            -- Collapse all
            ["z"] = "close_all_nodes",
            ["Z"] = "expand_all_nodes",
          },
        },
        filesystem = {
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = { "node_modules", ".git", "__pycache__", ".DS_Store" },
          },
        },
        buffers = {
          follow_current_file = { enabled = true },
        },
        git_status = {
          window = { position = "float" },
        },
      })
    end,
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
}
