-- ============================================================================
-- NVIM-TREE CONFIG - File Explorer
-- ============================================================================

require("nvim-tree").setup({
  -- Disable netrw
  disable_netrw = true,
  hijack_netrw = true,

  -- View settings
  view = {
    side = "left",
    width = 30,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },

  -- Renderer
  renderer = {
    highlight_git = true,
    highlight_opened_files = "none",
    root_folder_label = ":~:s?$?/..?",
    indent_markers = {
      enable = false,
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " -> ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = ">",
          arrow_open = "v",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "M",
          staged = "S",
          unmerged = "U",
          renamed = "R",
          untracked = "?",
          deleted = "D",
          ignored = "I",
        },
      },
    },
  },

  -- Filters
  filters = {
    dotfiles = false,
    custom = { ".git", "node_modules", ".cache" },
  },

  -- Git integration
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },

  -- Actions
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },

  -- Update focused file
  update_focused_file = {
    enable = true,
    update_root = false,
  },

  -- Diagnostics
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = "H",
      info = "I",
      warning = "W",
      error = "E",
    },
  },
})
