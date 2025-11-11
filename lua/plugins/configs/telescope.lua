-- ============================================================================
-- TELESCOPE CONFIG - Fuzzy Finder
-- ============================================================================

local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    -- Layout
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },

    sorting_strategy = "ascending",

    -- Minimal border style
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

    -- Mappings
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<Esc>"] = actions.close,
      },
      n = {
        ["q"] = actions.close,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
    },

    -- Performance
    file_ignore_patterns = {
      "node_modules",
      "%.git/",
      "target/",
      "build/",
      "dist/",
      "%.class",
    },

    -- UI
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    path_display = { "truncate" },
    winblend = 0,
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
  },

  pickers = {
    find_files = {
      hidden = false,
      find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
    },
    live_grep = {
      additional_args = function()
        return { "--hidden" }
      end,
    },
    current_buffer_fuzzy_find = {
      layout_config = {
        prompt_position = "top",
      },
    },
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Load fzf extension
pcall(telescope.load_extension, "fzf")
